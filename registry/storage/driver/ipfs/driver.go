package ipfs

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	gopath "path"
	"strings"
	"time"

	dcontext "github.com/distribution/distribution/v3/context"
	storagedriver "github.com/distribution/distribution/v3/registry/storage/driver"
	"github.com/distribution/distribution/v3/registry/storage/driver/base"
	"github.com/distribution/distribution/v3/registry/storage/driver/factory"
	"github.com/ipfs/go-cid"
	httpapi "github.com/ipfs/go-ipfs-http-client"
	"github.com/ipfs/go-merkledag"
	"github.com/ipfs/go-mfs"
	unixfs "github.com/ipfs/go-unixfs"
	coreapi "github.com/ipfs/interface-go-ipfs-core"
	"github.com/ipfs/interface-go-ipfs-core/options"
	ipfspath "github.com/ipfs/interface-go-ipfs-core/path"
	ma "github.com/multiformats/go-multiaddr"
)

/*
cache address to blob hash?
save all address to blob in a directory?
save that in ipns
ideally i want a mutable distributed set
practically can use a CAS if ipns is consistent.

*/

const (
	DriverName = "ipfs"
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
	Address  string `json:"address"`
	IpnsKey  string `json:"ipns_key"`
	ReadOnly bool   `json:"read_only"`
}

// Create returns a new storagedriver.StorageDriver with the given parameters
// Parameters will vary by driver and may be ignored
// Each parameter key must only consist of lowercase letters and numbers
func (s *ipfsDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {

	data, err := json.Marshal(parameters)
	if err != nil {
		return nil, err
	}
	var params DriverParameters
	err = json.Unmarshal(data, &params)
	if err != nil {
		return nil, err
	}

	if params.Address == "" {
		return nil, fmt.Errorf("please provide ipfs node address. for example: /ip4/1.2.3.4/tcp/80")
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

	d, err := NewDriverFromAPI(api, params.IpnsKey, params.ReadOnly)
	return Wrap(d), err
}

func Wrap(d *IpfsDriver) storagedriver.StorageDriver {
	if d == nil {
		return nil
	}
	return &Driver{
		baseEmbed: baseEmbed{
			Base: base.Base{
				StorageDriver: d,
			},
		},
	}
}

func NewDriverFromAPI(api coreapi.CoreAPI, ipnsKey string, readOnly bool) (*IpfsDriver, error) {
	ctx := context.Background()

	var resolved ipfspath.Resolved
	path, err := api.Name().Resolve(ctx, ipnsKey)
	if err == nil {
		resolved, err = api.ResolvePath(ctx, path)
		if err != nil {
			return nil, err
		}
	}

	dag := api.Dag()

	var nd *merkledag.ProtoNode
	switch {
	case err == coreapi.ErrResolveFailed || resolved == nil:
		nd = unixfs.EmptyDirNode()
		err := dag.Add(ctx, nd)
		if err != nil {
			return nil, fmt.Errorf("failure writing to dagstore: %s", err)
		}
	case err == nil:
		c := resolved.Cid()

		rnd, err := dag.Get(ctx, c)
		if err != nil {
			return nil, fmt.Errorf("error loading filesroot from DAG: %s", err)
		}

		pbnd, ok := rnd.(*merkledag.ProtoNode)
		if !ok {
			return nil, merkledag.ErrNotProtobuf
		}

		nd = pbnd
	default:
		return nil, err
	}

	rnode := unixfs.EmptyDirNode()
	driver := &IpfsDriver{api: api, ctx: ctx, ipnsKey: ipnsKey, readOnly: readOnly}

	driver.root, err = mfs.NewRoot(ctx, dag, rnode, mfs.PubFunc(driver.newRoot))
	return driver, err
}

// IpfsDriver implements the storagedriver.StorageDriver interface
type IpfsDriver struct {
	api      coreapi.CoreAPI
	ctx      context.Context
	ipnsKey  string
	readOnly bool
	root     *mfs.Root
}

func (s *IpfsDriver) newRoot(ctx context.Context, c cid.Cid) error {
	_, err := s.api.Name().Publish(ctx, ipfspath.IpfsPath(c), options.Name.Key(s.ipnsKey), options.Name.ValidTime(time.Hour*24*365))
	return err
}

// Name returns the human-readable "name" of the driver, useful in error
// messages and logging. By convention, this will just be the registration
// name, but drivers may provide other information here.
func (s *IpfsDriver) Name() string {
	return DriverName
}
func (s *IpfsDriver) reader(ctx context.Context, path string) (mfs.FileDescriptor, error) {
	return s.fd(ctx, path, mfs.Flags{Read: true})
}

func (s *IpfsDriver) fd(ctx context.Context, path string, flags mfs.Flags) (mfs.FileDescriptor, error) {
	fsn, err := mfs.Lookup(s.root, path)
	if err != nil {
		return nil, err
	}

	fi, ok := fsn.(*mfs.File)
	if !ok {
		return nil, fmt.Errorf("%s was not a file", path)
	}

	rfd, err := fi.Open(flags)
	if err != nil {
		return nil, err
	}
	return rfd, nil
}
func (s *IpfsDriver) writer(ctx context.Context, path string) (mfs.FileDescriptor, error) {
	return s.fd(ctx, path, mfs.Flags{Read: true})
}

// GetContent retrieves the content stored at "path" as a []byte.
// This should primarily be used for small objects.
func (s *IpfsDriver) GetContent(ctx context.Context, path string) ([]byte, error) {
	rfd, err := s.reader(ctx, path)
	if err != nil {
		return nil, err
	}

	defer rfd.Close()

	return ioutil.ReadAll(rfd)
}

// PutContent stores the []byte content at a location designated by "path".
// This should primarily be used for small objects.
func (s *IpfsDriver) PutContent(ctx context.Context, path string, content []byte) (retErr error) {
	fi, err := getFileHandleForWriting(s.root, path, true, nil)
	if err != nil {
		return err
	}

	wfd, err := fi.Open(mfs.Flags{Write: true, Sync: true})
	if err != nil {
		return err
	}

	defer func() {
		err := wfd.Close()
		if err != nil {
			if retErr == nil {
				retErr = err
			} else {
				logger(ctx).Error("files: error closing file mfs file descriptor", err)
			}
		}
	}()

	if err := wfd.Truncate(0); err != nil {
		return err
	}

	_, err = io.Copy(wfd, bytes.NewBuffer(content))
	return err
}

// Reader retrieves an io.ReadCloser for the content stored at "path"
// with a given byte offset.
// May be used to resume reading a stream by providing a nonzero offset.
func (s *IpfsDriver) Reader(ctx context.Context, path string, offset int64) (io.ReadCloser, error) {
	if offset < 0 {
		return nil, storagedriver.InvalidOffsetError{Path: path, Offset: offset, DriverName: DriverName}
	}

	rfd, err := s.reader(ctx, path)
	if err != nil {
		return nil, err
	}

	_, err = rfd.Seek(offset, io.SeekStart)
	if err != nil {
		logger(ctx).Error("seekfail: ", err)
		rfd.Close()
		return nil, err
	}

	return rfd, nil
}

// this was taken from upstream:
// https://github.com/ipfs/go-ipfs/blob/c2e6a22bba886aa494765f6b647aaa3d18f0f3d6/core/commands/files.go#L362
// with minor adjustments
func (s *IpfsDriver) rm(ctx context.Context, path string) error {

	path, err := checkPath(path)
	if err != nil {
		return err
	}

	if path == "/" {
		return fmt.Errorf("cannot delete root")
	}

	// 'rm a/b/c/' will fail unless we trim the slash at the end
	if path[len(path)-1] == '/' {
		path = path[:len(path)-1]
	}

	// if '--force' specified, it will remove anything else,
	// including file, directory, corrupted node, etc
	force := true

	dir, name := gopath.Split(path)

	pdir, err := getParentDir(s.root, dir)
	if err != nil {
		if force && err == os.ErrNotExist {
			return nil
		}
		return fmt.Errorf("parent lookup: %s", err)
	}

	if force {
		err := pdir.Unlink(name)
		if err != nil {
			if err == os.ErrNotExist {
				return nil
			}
			return err
		}
		return pdir.Flush()
	}

	// get child node by name, when the node is corrupted and nonexistent,
	// it will return specific error.
	child, err := pdir.Child(name)
	if err != nil {
		return err
	}

	dashr := true

	switch child.(type) {
	case *mfs.Directory:
		if !dashr {
			return fmt.Errorf("%s is a directory, use -r to remove directories", path)
		}
	}

	err = pdir.Unlink(name)
	if err != nil {
		return err
	}

	return pdir.Flush()
}

func (s *IpfsDriver) cp(ctx context.Context, src, dst string) error {

	src, err := checkPath(src)
	if err != nil {
		return err
	}
	src = strings.TrimRight(src, "/")

	dst, err = checkPath(dst)
	if err != nil {
		return err
	}

	if dst[len(dst)-1] == '/' {
		dst += gopath.Base(src)
	}

	node, err := getNodeFromPath(ctx, s.root, s.api, src)
	if err != nil {
		return fmt.Errorf("cp: cannot get node from path %s: %s", src, err)
	}
	mkParents := true
	if mkParents {
		err := ensureContainingDirectoryExists(s.root, dst, nil)
		if err != nil {
			return err
		}
	}

	err = mfs.PutNode(s.root, dst, node)
	if err != nil {
		return fmt.Errorf("cp: cannot put node in path %s: %s", dst, err)
	}
	flush := true
	if flush {
		_, err := mfs.FlushPath(ctx, s.root, dst)
		if err != nil {
			return fmt.Errorf("cp: cannot flush the created file %s: %s", dst, err)
		}
	}

	return nil

}

// Writer returns a FileWriter which will store the content written to it
// at the location designated by "path" after the call to Commit.
func (s *IpfsDriver) Writer(ctx context.Context, path string, append bool) (w storagedriver.FileWriter, retErr error) {

	fi, err := getFileHandleForWriting(s.root, path, true, nil)
	if err != nil {
		return nil, err
	}

	wfd, err := fi.Open(mfs.Flags{Write: true, Sync: true})
	if err != nil {
		return nil, err
	}
	defer func() {
		if retErr != nil {
			wfd.Close()
		}
	}()

	var size int64
	if append {
		wfd.Seek(0, io.SeekEnd)
		size, err = fi.Size()
		if err != nil {
			return nil, err
		}
	} else {
		err := wfd.Truncate(0)
		if err != nil {
			return nil, err
		}
	}

	w = &writer{ctx: ctx, parent: s, size: size, path: path, wfd: wfd}
	return w, nil
}

type writeResult struct {
	cid cid.Cid
	err error
}
type writer struct {
	ctx context.Context
	wfd mfs.FileDescriptor

	path string

	parent *IpfsDriver

	closed    bool
	committed bool
	cancelled bool
	size      int64
}

func (w *writer) Write(p []byte) (n int, err error) {
	n, err = w.wfd.Write(p)
	w.size += int64(n)
	return n, err
}

func (w *writer) Close() error {
	if w.closed {
		return fmt.Errorf("already closed")
	}
	w.closed = true
	return w.wfd.Close()

}

// Size returns the number of bytes written to this FileWriter.
func (w *writer) Size() int64 {
	return w.size
}

// Cancel removes any written content from this FileWriter.
func (w *writer) Cancel() error {
	if w.closed {
		return fmt.Errorf("already closed")
	} else if w.cancelled {
		return fmt.Errorf("already cancelled")
	}
	w.cancelled = true
	// close, because we have to (deadlock otherwise)
	w.Close()

	// remove file
	return w.parent.rm(w.ctx, w.path)
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
	w.committed = true
	// close, as not closing wfd might entail a dead lock
	return w.wfd.Flush()
}

// Stat retrieves the FileInfo for the given path, including the current
// size in bytes and the creation time.
func (s *IpfsDriver) Stat(ctx context.Context, path string) (storagedriver.FileInfo, error) {
	fsn, err := mfs.Lookup(s.root, path)
	if err != nil {
		return nil, err
	}

	fi := storagedriver.FileInfoFields{
		Path: path,
	}
	if fsn.Type() == mfs.TDir {
		fi.IsDir = true
	} else {
		fi.Size = fi.Size
	}

	return storagedriver.FileInfoInternal{FileInfoFields: fi}, nil
}

// List returns a list of the objects that are direct descendants of the
//given path.
func (s *IpfsDriver) List(ctx context.Context, subPath string) ([]string, error) {

	var arg string

	if len(subPath) == 0 {
		arg = "/"
	} else {
		arg = subPath
	}

	path, err := checkPath(arg)
	if err != nil {
		return nil, err
	}

	fsn, err := mfs.Lookup(s.root, path)
	if err != nil {
		return nil, err
	}

	switch fsn := fsn.(type) {
	case *mfs.Directory:
		var output []string
		names, err := fsn.ListNames(ctx)
		if err != nil {
			return nil, err
		}

		for _, name := range names {
			output = append(output, gopath.Join(subPath, name))
		}
		return names, nil

	default:
		return nil, errors.New("not a directory or unrecognized type")
	}
}

// Move moves an object stored at sourcePath to destPath, removing the
// original object.
// Note: This may be no more efficient than a copy followed by a delete for
// many implementations.
func (s *IpfsDriver) Move(ctx context.Context, sourcePath string, destPath string) error {

	flush := true

	src, err := checkPath(sourcePath)
	if err != nil {
		return err
	}
	dst, err := checkPath(destPath)
	if err != nil {
		return err
	}

	err = mfs.Mv(s.root, src, dst)
	if err == nil && flush {
		_, err = mfs.FlushPath(ctx, s.root, "/")
	}
	return err
}

// Delete recursively deletes all objects stored at "path" and its subpaths.
func (s *IpfsDriver) Delete(ctx context.Context, path string) error {
	return s.rm(ctx, path)
}

// URLFor returns a URL which may be used to retrieve the content stored at
// the given path, possibly using the given options.
// May return an ErrUnsupportedMethod in certain StorageDriver
// implementations.
func (s *IpfsDriver) URLFor(ctx context.Context, path string, options map[string]interface{}) (string, error) {
	return "", storagedriver.ErrUnsupportedMethod{DriverName: DriverName}
}

// Walk traverses a filesystem defined within driver, starting
// from the given path, calling f on each file.
// If the returned error from the WalkFn is ErrSkipDir and fileInfo refers
// to a directory, the directory will not be entered and Walk
// will continue the traversal.  If fileInfo refers to a normal file, processing stops
func (s *IpfsDriver) Walk(ctx context.Context, path string, f storagedriver.WalkFn) error {
	return storagedriver.WalkFallback(ctx, s, path, f)
}
