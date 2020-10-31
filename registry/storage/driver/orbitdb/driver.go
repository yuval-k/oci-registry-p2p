package orbitdb

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"strings"
	"sync"
	"time"

	orbitdb "berty.tech/go-orbit-db"
	"berty.tech/go-orbit-db/stores/basestore"
	dcontext "github.com/docker/distribution/context"
	"github.com/docker/distribution/registry/storage/driver"
	storagedriver "github.com/docker/distribution/registry/storage/driver"
	"github.com/docker/distribution/registry/storage/driver/base"
	"github.com/docker/distribution/registry/storage/driver/factory"
	"github.com/ipfs/go-cid"
	files "github.com/ipfs/go-ipfs-files"
	httpapi "github.com/ipfs/go-ipfs-http-client"
	coreapi "github.com/ipfs/interface-go-ipfs-core"
	ipfspath "github.com/ipfs/interface-go-ipfs-core/path"
	ma "github.com/multiformats/go-multiaddr"
	"go.uber.org/atomic"
)

/*
cache address to blob hash?
save all address to blob in a directory?
save that in ipns
ideally i want a mutable distributed set
practically can use a CAS if ipns is consistent.

*/

const (
	DriverName = "orbitdb"
)

func init() {
	factory.Register(DriverName, &ipfsDriverFactory{})
}

func logger(ctx context.Context) dcontext.Logger {

	return dcontext.GetLoggerWithFields(ctx, map[interface{}]interface{}{
		"driver": DriverName,
	})
}

// ipfsDriverFactory implements the factory.StorageDriverFactory interface
type ipfsDriverFactory struct{}

type baseEmbed struct {
	base.Base
}
type Driver struct {
	baseEmbed
}

type DriverParameters struct {
	Address   string `json:"address"`
	DbAddress string `json:"db_address"`
	CacheDir  string `json:"cache_dir"`
}

// Create returns a new storagedriver.StorageDriver with the given parameters
// Parameters will vary by driver and may be ignored
// Each parameter key must only consist of lowercase letters and numbers
func (s *ipfsDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {

	ipfsNodeAddress, ok := parameters["address"].(string)
	if !ok {
		return nil, fmt.Errorf("please provide ipfs node address. for example: /ip4/1.2.3.4/tcp/80")
	}
	dbNodeAddress, ok := parameters["db_address"].(string)
	if !ok {
		return nil, fmt.Errorf("please provide orbitdb address. create it out of band")
	}

	cacheDir, _ := parameters["cache_dir"].(string)

	params := DriverParameters{
		Address:   ipfsNodeAddress,
		DbAddress: dbNodeAddress,
		CacheDir:  cacheDir,
	}

	return NewDriverFromParams(params)
}

func NewDriverFromParams(params DriverParameters) (storagedriver.StorageDriver, error) {

	addr, err := ma.NewMultiaddr(params.Address)
	if err != nil {
		return nil, err
	}
	api, err := httpapi.NewApi(addr)
	if err != nil {
		return nil, err
	}
	return NewDriverFromAPI(api, params.CacheDir, params.DbAddress)
}

func NewDriverFromAPI(api coreapi.CoreAPI, cacheDir, dbaddr string) (storagedriver.StorageDriver, error) {

	options := &orbitdb.NewOrbitDBOptions{}

	if cacheDir != "" {
		options.Directory = &cacheDir
	}
	ctx := context.Background()
	db, err := orbitdb.NewOrbitDB(ctx, api, options)
	if err != nil {
		return nil, err
	}
	// TODO: document that we need to make sure only one writer.
	createoptions := &orbitdb.CreateDBOptions{}

	kv, err := db.KeyValue(ctx, dbaddr, createoptions)
	if err != nil {
		return nil, err
	}

	d := &ipfsDriver{
		api:          api,
		kv:           kv,
		ctx:          ctx,
		saveSnapshot: cacheDir != "",
	}

	err = d.kv.LoadFromSnapshot(context.Background())
	if err != nil {
		logger(ctx).Debugln("failed loading snapshot", err)
	}

	return &Driver{
		baseEmbed: baseEmbed{
			Base: base.Base{
				StorageDriver: d,
			},
		},
	}, nil
}

// ipfsDriver implements the storagedriver.StorageDriver interface
type ipfsDriver struct {
	api          coreapi.CoreAPI
	kv           orbitdb.KeyValueStore
	ctx          context.Context
	saveSnapshot bool

	snapStarter sync.Once
	kick        chan struct{}
}

// Name returns the human-readable "name" of the driver, useful in error
// messages and logging. By convention, this will just be the registration
// name, but drivers may provide other information here.
func (s *ipfsDriver) Name() string {
	return "ipfs"
}

// GetContent retrieves the content stored at "path" as a []byte.
// This should primarily be used for small objects.
func (s *ipfsDriver) GetContent(ctx context.Context, path string) ([]byte, error) {
	r, err := s.Reader(ctx, path, 0)
	if err != nil {
		return nil, err
	}
	return ioutil.ReadAll(r)
}

// PutContent stores the []byte content at a location designated by "path".
// This should primarily be used for small objects.
func (s *ipfsDriver) PutContent(ctx context.Context, path string, content []byte) error {
	defer s.queueSnapshot()
	f := files.NewBytesFile(content)

	cid, err := s.api.Unixfs().Add(ctx, f)
	if err != nil {
		return err
	}

	return s.set(ctx, path, cid.Cid())
}

func (s *ipfsDriver) queueSnapshot() {
	if !s.saveSnapshot {
		return
	}
	s.snapStarter.Do(func() {
		s.kick = make(chan struct{}, 1)
		go func() {
			ctx := s.ctx
			for range s.kick {
				cid, err := basestore.SaveSnapshot(ctx, s.kv)
				if err != nil {
					// log something
					logger(ctx).Debugln("failed saving snapshot", err)
				} else {
					logger(ctx).Debugln("saved snapshot", cid)
					// log something
				}
				// make sure we don't save too much..
				time.Sleep(10 * time.Second)
			}
		}()
	})
	select {
	case s.kick <- struct{}{}:
	default:
	}
}

func (s *ipfsDriver) get(ctx context.Context, path string) ([]cid.Cid, error) {

	bytes, err := s.kv.Get(ctx, path)
	if err != nil {
		return nil, err
	}
	if bytes == nil {
		return nil, storagedriver.PathNotFoundError{Path: path, DriverName: DriverName}
	}
	var res []cid.Cid
	return res, json.Unmarshal(bytes, &res)

}

func (s *ipfsDriver) set(ctx context.Context, path string, cids ...cid.Cid) error {
	if cids == nil {
		cids = make([]cid.Cid, 0)
	}
	bytes, err := json.Marshal(cids)
	if err != nil {
		return err
	}

	_, err = s.kv.Put(ctx, path, bytes)
	return err
}

// Reader retrieves an io.ReadCloser for the content stored at "path"
// with a given byte offset.
// May be used to resume reading a stream by providing a nonzero offset.
func (s *ipfsDriver) Reader(ctx context.Context, path string, offset int64) (io.ReadCloser, error) {
	if offset < 0 {
		return nil, storagedriver.InvalidOffsetError{Path: path, Offset: offset, DriverName: DriverName}
	}
	uoffset := uint64(offset)
	cids, err := s.get(ctx, path)
	if err != nil {
		return nil, err
	}

	totalSize := uint64(0)
	for i, cid := range cids {
		resolved := ipfspath.IpfsPath(cid)
		node, err := s.api.Unixfs().Get(ctx, resolved)
		if err != nil {
			return nil, err
		}
		res, ok := node.(files.File)
		if !ok {
			return nil, errors.New("unable to cast fetched data as a file")
		}
		size, err := res.Size()
		if err != nil {
			return nil, err
		}
		usize := uint64(size)
		if uoffset < (totalSize + usize) {
			return &reader{ctx: ctx, unixapi: s.kv.IPFS().Unixfs(), cids: cids[i:], firstOffset: uoffset - totalSize}, nil
		}
		totalSize += usize
	}

	return nil, storagedriver.InvalidOffsetError{Path: path, Offset: offset, DriverName: DriverName}
}

type reader struct {
	ctx         context.Context
	cids        []cid.Cid
	firstOffset uint64
	unixapi     coreapi.UnixfsAPI

	lazyReaders []*lazyReader
	reader      io.Reader
}

func (r *reader) Read(p []byte) (n int, err error) {
	if len(r.lazyReaders) == 0 {
		var readers []io.Reader
		for i, cid := range r.cids {
			var off uint64
			if i == 0 {
				off = r.firstOffset
			}
			lr := &lazyReader{ctx: r.ctx, unixapi: r.unixapi, cid: cid, offset: off}
			r.lazyReaders = append(r.lazyReaders, lr)
			readers = append(readers, lr)
		}
		r.reader = io.MultiReader(readers...)
	}
	return r.reader.Read(p)
}

func (r *reader) Close() error {

	for _, lr := range r.lazyReaders {
		if lr != nil {
			// TODO: log error?
			lr.Close()
		}
	}
	return nil
}

type lazyReader struct {
	ctx     context.Context
	unixapi coreapi.UnixfsAPI
	cid     cid.Cid
	offset  uint64

	res files.File
}

func (r *lazyReader) Read(p []byte) (n int, err error) {
	if r.res == nil {
		resolved := ipfspath.IpfsPath(r.cid)
		node, err := r.unixapi.Get(r.ctx, resolved)
		if err != nil {
			return 0, err
		}
		var ok bool
		r.res, ok = node.(files.File)
		if !ok {
			return 0, errors.New("unable to cast fetched data as a file")
		}
		if r.offset != 0 {
			r.res.Seek(int64(r.offset), io.SeekStart)
		}
	}

	return r.res.Read(p)
}

func (r *lazyReader) Close() error {
	if r.res != nil {
		r.res.Close()
	}
	return nil
}

// Writer returns a FileWriter which will store the content written to it
// at the location designated by "path" after the call to Commit.
func (s *ipfsDriver) Writer(ctx context.Context, path string, append bool) (driver.FileWriter, error) {
	// we can't append so we will update the parts of the path
	w := &writer{ctx: ctx, path: path, append: append, parent: s}
	if append {
		size, err := s.getSize(ctx, path)
		if err == nil {
			w.written.Store(size)
		}
	}

	return w, nil
}

type writeResult struct {
	cid cid.Cid
	err error
}
type writer struct {
	ctx    context.Context
	path   string
	append bool

	reader *io.PipeReader
	writer *io.PipeWriter
	parent *ipfsDriver

	writeResult chan writeResult
	written     atomic.Int64
	closed      bool
	committed   bool
	cancelled   bool
}

func (w *writer) Write(p []byte) (n int, err error) {
	l := logger(w.ctx)
	l.Debug("writing len=", len(p))
	defer l.Debug("wrote", n, err)
	if w.reader == nil {
		w.reader, w.writer = io.Pipe()
		w.writeResult = make(chan writeResult, 1)

		go func() {
			defer close(w.writeResult)
			defer w.reader.Close()
			f := files.NewReaderFile(w.reader)
			resolved, err := w.parent.api.Unixfs().Add(w.ctx, f)
			var cid cid.Cid
			if err == nil {
				cid = resolved.Cid()
			}
			w.writeResult <- writeResult{
				cid: cid,
				err: err,
			}
		}()
	}
	n, err = w.writer.Write(p)
	w.written.Add(int64(n))
	return
}

func (w *writer) Close() error {
	if w.closed {
		return fmt.Errorf("already closed")
	}
	w.closed = true
	w.close()
	return w.flush()

}
func (w *writer) close() error {
	if w.writer != nil {
		return w.writer.Close()
	}
	return nil
}

// Size returns the number of bytes written to this FileWriter.
func (w *writer) Size() int64 {
	return w.written.Load()
}

// Cancel removes any written content from this FileWriter.
func (w *writer) Cancel() error {
	if w.closed {
		return fmt.Errorf("already closed")
	} else if w.committed {
		return fmt.Errorf("already committed")
	}
	w.cancelled = true
	if w.writer != nil {
		return w.writer.CloseWithError(fmt.Errorf("cancelled"))
	}
	return nil
}

// Commit flushes all content written to this FileWriter and makes it
// available for future calls to StorageDriver.GetContent and
// StorageDriver.Reader.
func (w *writer) Commit() error {
	if w.closed {
		return fmt.Errorf("already closed")
	} else if w.committed {
		return fmt.Errorf("already committed")
	} else if w.cancelled {
		return fmt.Errorf("already cancelled")
	}

	defer w.parent.queueSnapshot()
	w.close()
	err := w.flush()
	if err == nil {
		w.committed = true
	}
	return err
}
func (w *writer) flush() error {
	if w.reader == nil {
		if !w.append {
			return w.parent.set(w.ctx, w.path)
		}
		return nil
	}
	// get results:
	select {
	case <-w.ctx.Done():
		return w.ctx.Err()
	case result, ok := <-w.writeResult:
		if !ok {
			return fmt.Errorf("read write result twice")
		}
		if result.err != nil {
			return result.err
		}
		cid := result.cid

		if w.append {
			//append
			cids, err := w.parent.get(w.ctx, w.path)
			if err != nil {
				return err
			}
			cids = append(cids, cid)
			return w.parent.set(w.ctx, w.path, cids...)
		} else {
			// overwrite
			return w.parent.set(w.ctx, w.path, cid)
		}
	}
}

// Stat retrieves the FileInfo for the given path, including the current
// size in bytes and the creation time.
func (s *ipfsDriver) Stat(ctx context.Context, path string) (driver.FileInfo, error) {

	allpaths := s.kv.All()

	var isdir bool
	for k := range allpaths {
		if strings.HasPrefix(k, path) && k != path {
			isdir = true
			break
		}
	}

	fi := storagedriver.FileInfoFields{
		Path: path,
	}
	if isdir {
		fi.IsDir = true
	} else {
		var err error
		fi.Size, err = s.getSize(ctx, path)
		if err != nil {
			return nil, err
		}
	}

	return storagedriver.FileInfoInternal{FileInfoFields: fi}, nil
}
func (s *ipfsDriver) getSize(ctx context.Context, path string) (int64, error) {
	cids, err := s.get(ctx, path)
	if err != nil {
		return 0, err
	}

	totalSize := int64(0)
	for _, cid := range cids {
		resolved := ipfspath.IpfsPath(cid)
		node, err := s.api.Unixfs().Get(ctx, resolved)
		if err != nil {
			return 9, err
		}
		res, ok := node.(files.File)
		if !ok {
			return 0, errors.New("unable to cast fetched data as a file")
		}
		size, err := res.Size()
		if err != nil {
			return 0, err
		}
		totalSize += size
	}

	return totalSize, nil
}

// List returns a list of the objects that are direct descendants of the
//given path.
func (s *ipfsDriver) List(ctx context.Context, path string) ([]string, error) {
	var children []string
	for k := range s.kv.All() {
		if strings.HasPrefix(k, path) {
			children = append(children, k)
		}
	}
	return children, nil
}

// Move moves an object stored at sourcePath to destPath, removing the
// original object.
// Note: This may be no more efficient than a copy followed by a delete for
// many implementations.
func (s *ipfsDriver) Move(ctx context.Context, sourcePath string, destPath string) error {
	hash, err := s.kv.Get(ctx, sourcePath)
	if err != nil {
		return err
	}
	_, err = s.kv.Put(ctx, destPath, hash)
	return err
}

// Delete recursively deletes all objects stored at "path" and its subpaths.
func (s *ipfsDriver) Delete(ctx context.Context, path string) error {
	_, err := s.kv.Delete(ctx, path)
	return err
}

// URLFor returns a URL which may be used to retrieve the content stored at
// the given path, possibly using the given options.
// May return an ErrUnsupportedMethod in certain StorageDriver
// implementations.
func (s *ipfsDriver) URLFor(ctx context.Context, path string, options map[string]interface{}) (string, error) {
	return "", storagedriver.ErrUnsupportedMethod{DriverName: DriverName}
}

// Walk traverses a filesystem defined within driver, starting
// from the given path, calling f on each file.
// If the returned error from the WalkFn is ErrSkipDir and fileInfo refers
// to a directory, the directory will not be entered and Walk
// will continue the traversal.  If fileInfo refers to a normal file, processing stops
func (s *ipfsDriver) Walk(ctx context.Context, path string, f driver.WalkFn) error {
	return storagedriver.WalkFallback(ctx, s, path, f)
}
