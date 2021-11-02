package ipfsdriver

import (
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	gopath "path"
	"strings"
	"sync"
	"time"

	dcontext "github.com/distribution/distribution/v3/context"
	storagedriver "github.com/distribution/distribution/v3/registry/storage/driver"
	"github.com/distribution/distribution/v3/registry/storage/driver/base"
	"github.com/distribution/distribution/v3/registry/storage/driver/factory"
	"github.com/ipfs/go-cid"
	httpapi "github.com/ipfs/go-ipfs-http-client"
	ipld "github.com/ipfs/go-ipld-format"
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
	// IpfsApiAddress is the address of the ipfs node's api port.
	// In multi address format.
	// `ipfsapiaddress` in the yaml
	IpfsApiAddress string
	// IPNS key to write to our MFS root to. `writeipnskey` in yaml.
	WriteIpnsKey string

	// Optional list of IPNS keys to read other MFS roots.
	// This allows you to specify the IPNS key of a remote node, and
	// share the images of that node. Thus enabling p2p registries.
	// `readonlyipnskeys` in yaml.
	ReadOnlyKeys []string
}

// Create returns a new storagedriver.StorageDriver with the given parameters
// Parameters will vary by driver and may be ignored
// Each parameter key must only consist of lowercase letters and numbers
func (s *ipfsDriverFactory) Create(parameters map[string]interface{}) (storagedriver.StorageDriver, error) {
	ipfsaddress, ok := parameters["ipfsapiaddress"]
	if !ok || fmt.Sprint(ipfsaddress) == "" {
		ipfsaddress = "/ip4/127.0.0.1/tcp/5001"
	}
	writeipnskey, ok := parameters["writeipnskey"]
	if !ok || fmt.Sprint(writeipnskey) == "" {
		writeipnskey = ""
	}

	params := DriverParameters{
		IpfsApiAddress: fmt.Sprint(ipfsaddress),
		WriteIpnsKey:   fmt.Sprint(writeipnskey),
	}

	readonlyipnskeys, ok := parameters["readonlyipnskeys"]
	if ok && fmt.Sprint(readonlyipnskeys) != "" {
		switch rokeys := readonlyipnskeys.(type) {
		case []string:
			params.ReadOnlyKeys = rokeys
		case string:
			params.ReadOnlyKeys = strings.Split(rokeys, ",")
			for i, v := range params.ReadOnlyKeys {
				params.ReadOnlyKeys[i] = strings.TrimSpace(v)
			}
		default:
			return nil, fmt.Errorf("readonlyipnskeys must be a string or a list of strings")
		}
	}

	return NewDriverFromParams(params)
}

func NewDriverFromParams(params DriverParameters) (storagedriver.StorageDriver, error) {

	addr, err := ma.NewMultiaddr(params.IpfsApiAddress)
	if err != nil {
		return nil, err
	}
	api, err := httpapi.NewApi(addr)
	if err != nil {
		return nil, err
	}

	d, err := NewDriverFromAPI(context.Background(), api, params.WriteIpnsKey, params.ReadOnlyKeys)
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

func getProtoNodeForKey(ctx context.Context, api coreapi.CoreAPI, ipnsKey string) (*merkledag.ProtoNode, error) {
	var resolved ipfspath.Resolved
	path, err := api.Name().Resolve(ctx, ipnsKey)
	if err == nil {
		resolved, err = api.ResolvePath(ctx, path)
		if err != nil {
			return nil, err
		}
	}

	dag := api.Dag()
	switch {
	case err == coreapi.ErrResolveFailed || resolved == nil:
		nd := unixfs.EmptyDirNode()
		err := dag.Add(ctx, nd)
		if err != nil {
			return nil, fmt.Errorf("failure writing to dagstore: %s", err)
		}
		return nd, nil
	case err == nil:
		c := resolved.Cid()
		l := dcontext.GetLoggerWithField(ctx, "ipns-value", c.String())
		l.Debug("resolving initial ipns root entry")
		rnd, err := dag.Get(ctx, c)
		if err != nil {
			return nil, fmt.Errorf("error loading filesroot from DAG: %s", err)
		}
		l.Debug("resolved node from initial ipns root entry")

		nd, ok := rnd.(*merkledag.ProtoNode)
		if !ok {
			return nil, merkledag.ErrNotProtobuf
		}
		return nd, nil
	default:
		return nil, err
	}
}

func NewDriverFromAPI(ctx context.Context, api coreapi.CoreAPI, ipnsKeyWrite string, ipnsKeyReadOnly []string) (readydriver *IpfsDriver, err error) {
	driver := &IpfsDriver{api: api, ctx: ctx}
	defer func() {
		if err != nil {
			driver.Close()
		}
	}()
	dag := api.Dag()

	if ipnsKeyWrite != "" {
		driver.writeIpnsKey = ipnsKeyWrite
		nd, err := getProtoNodeForKey(ctx, api, ipnsKeyWrite)
		if err != nil {
			return nil, err
		}
		driver.writeRoot, err = mfs.NewRoot(ctx, dag, nd, mfs.PubFunc(driver.newRoot))
		if err != nil {
			return nil, err
		}
		driver.readOnly = false
	} else {
		driver.readOnly = true
	}

	for _, ipnsKey := range ipnsKeyReadOnly {
		rrr, err := driver.newRefreshableReadonlyRoot(ipnsKey)
		if err != nil {
			return nil, err
		}
		driver.readonlyRoots = append(driver.readonlyRoots, rrr)
	}

	if driver.writeRoot == nil && len(driver.readonlyRoots) == 0 {
		return nil, fmt.Errorf("no IPNS keys provided")
	}

	return driver, nil
}

// IpfsDriver implements the storagedriver.StorageDriver interface
type IpfsDriver struct {
	api coreapi.CoreAPI
	ctx context.Context

	writeIpnsKey string
	writeRoot    *mfs.Root
	readOnly     bool

	readonlyRoots []*refreshableReadonlyRoot
}

func (s *IpfsDriver) root() *mfs.Root {
	return s.writeRoot
}

func (s *IpfsDriver) newRefreshableReadonlyRoot(ipnsKey string) (*refreshableReadonlyRoot, error) {
	// in read only mode, no need to publish the new root.
	// just keep trying to refresh it to get updates
	// we can probably use pub sub for this, but why bother?!
	nd, err := getProtoNodeForKey(s.ctx, s.api, ipnsKey)
	if err != nil {
		return nil, err
	}

	rrr := &refreshableReadonlyRoot{
		ctx:     s.ctx,
		api:     s.api,
		ipnsKey: ipnsKey,
		closed:  make(chan struct{}),
	}
	rrr.currentRoot, err = mfs.NewRoot(s.ctx, s.api.Dag(), nd, nil)
	go func() {
		for {
			select {
			case <-time.After(time.Second * 5):
				rrr.refreshRoot()
			case <-s.ctx.Done():
				return
			case <-rrr.closed:
				return
			}
		}
	}()
	return rrr, nil
}

type refreshableReadonlyRoot struct {
	ctx     context.Context
	api     coreapi.CoreAPI
	ipnsKey string
	closed  chan struct{}

	currentRoot     *mfs.Root
	currentRootLock sync.RWMutex
}

func (s *refreshableReadonlyRoot) Close() error {
	var err error
	if s.closed != nil {
		close(s.closed)
		err = s.currentRoot.Close()
		s.closed = nil
	}
	return err
}

func (s *refreshableReadonlyRoot) Root() *mfs.Root {
	s.currentRootLock.RLock()
	defer s.currentRootLock.RUnlock()
	return s.currentRoot
}

func (s *refreshableReadonlyRoot) refreshRoot() {
	l := logger(s.ctx)
	l.Debug("refreshRoot")
	var resolved ipfspath.Resolved
	path, err := s.api.Name().Resolve(s.ctx, s.ipnsKey)
	if err == nil {
		resolved, err = s.api.ResolvePath(s.ctx, path)
		if err != nil {
			l.WithError(err).Error("refreshRoot: resolve path")
			return
		}
	}

	dag := s.api.Dag()

	pbnd, err := s.getNodeFromCid(resolved.Cid())
	if err != nil {
		l.WithError(err).Error("refreshRoot: get node from cid")
		return
	}
	newroot, err := mfs.NewRoot(s.ctx, dag, pbnd, nil)
	if err != nil {
		l.WithError(err).Error("refreshRoot: new root")
		return
	}

	s.currentRootLock.Lock()
	defer s.currentRootLock.Unlock()
	s.currentRoot.Close()
	s.currentRoot = newroot
}

func (s *refreshableReadonlyRoot) getNodeFromCid(c cid.Cid) (*merkledag.ProtoNode, error) {
	dag := s.api.Dag()
	dcontext.GetLoggerWithField(s.ctx, "ipns-value", c.String()).Debug("resolved initial ipns root entry")
	rnd, err := dag.Get(s.ctx, c)
	if err != nil {
		return nil, fmt.Errorf("error loading filesroot from DAG: %s", err)
	}

	pbnd, ok := rnd.(*merkledag.ProtoNode)
	if !ok {
		return nil, merkledag.ErrNotProtobuf
	}
	return pbnd, nil

}

func (s *IpfsDriver) newRoot(ctx context.Context, c cid.Cid) error {
	name := s.api.Name()
	path := ipfspath.IpfsPath(c)
	key := options.Name.Key(s.writeIpnsKey)
	timeOpt := options.Name.ValidTime(time.Hour * 24 * 365)
	_, err := name.Publish(ctx, path, key, timeOpt)
	l := logger(ctx)
	if err != nil {
		l.WithError(err).Error("failed to publish ipns entry")
	}
	dcontext.GetLoggerWithField(ctx, "ipns-value", path.Cid().String()).Debug("published ipns entry")
	return err
}

// Name returns the human-readable "name" of the driver, useful in error
// messages and logging. By convention, this will just be the registration
// name, but drivers may provide other information here.
func (s *IpfsDriver) Name() string {
	return DriverName
}

func (s *IpfsDriver) Close() error {
	var err error
	if s.writeRoot != nil {
		tmperr := s.writeRoot.Close()
		if tmperr != nil {
			err = tmperr
		}
	}
	for _, rrr := range s.readonlyRoots {
		tmperr := rrr.Close()
		if tmperr != nil {
			err = tmperr
		}
	}
	return err
}

func (s *IpfsDriver) readonlyLookup(ctx context.Context, path string) (mfs.FSNode, error) {
	if s.writeRoot != nil {
		fd, err := mfs.Lookup(s.writeRoot, path)
		if err != nil && !os.IsNotExist(err) {
			return nil, err
		}
		if err == nil {
			return fd, nil
		}
	}

	for _, rrr := range s.readonlyRoots {
		fd, err := mfs.Lookup(rrr.Root(), path)
		if err != nil {
			if os.IsNotExist(err) {
				continue
			}
			return nil, err
		}
		return fd, nil
	}

	return nil, os.ErrNotExist
}

func (s *IpfsDriver) reader(ctx context.Context, path string) (mfs.FileDescriptor, error) {
	fsn, err := s.readonlyLookup(ctx, path)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, storagedriver.PathNotFoundError{Path: path}
		}
		return nil, err
	}

	fi, ok := fsn.(*mfs.File)
	if !ok {
		return nil, fmt.Errorf("%s was not a file", path)
	}

	fd, err := fi.Open(mfs.Flags{Read: true})
	if err != nil {
		return nil, err
	}
	if err != nil && os.IsNotExist(err) {

		return nil, storagedriver.PathNotFoundError{Path: path}
	}

	return fd, err
}

// GetContent retrieves the content stored at "path" as a []byte.
// This should primarily be used for small objects.
func (s *IpfsDriver) GetContent(ctx context.Context, path string) ([]byte, error) {
	l := logger(ctx)
	l.Debug("GetContent: ", "path", path)
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
	l := logger(ctx)
	l.Debug("PutContent: ", "path", path)

	if s.readOnly {
		return fmt.Errorf("cannot write to readonly ipfs driver")
	}

	fi, err := getFileHandleForWriting(s.root(), path, true, nil)
	if err != nil {
		l.Debug("failed to get file handle for writing" + err.Error())
		return err
	}

	wfd, err := fi.Open(mfs.Flags{Write: true, Sync: true})
	if err != nil {
		l.Debug("failed to open file for writing" + err.Error())
		return err
	}

	defer func() {
		err := wfd.Close()
		if err != nil {
			if retErr == nil {
				retErr = err
			} else {
				l.Error("files: error closing file mfs file descriptor", err)
			}
		}
	}()

	if err := wfd.Truncate(0); err != nil {
		l.Debug("failed to truncate file" + err.Error())
		return err
	}

	_, err = io.Copy(wfd, bytes.NewBuffer(content))
	if err != nil {
		l.Debug("failed to write to file" + err.Error())
		return err
	}

	return err
}

// Reader retrieves an io.ReadCloser for the content stored at "path"
// with a given byte offset.
// May be used to resume reading a stream by providing a nonzero offset.
func (s *IpfsDriver) Reader(ctx context.Context, path string, offset int64) (io.ReadCloser, error) {
	logger(ctx).Debug("files: reader", "path", path, "offset", offset)
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
	logger(ctx).Debug("rm: ", path)
	if s.readOnly {
		return fmt.Errorf("cannot write to readonly ipfs driver")
	}

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

	pdir, err := getParentDir(s.root(), dir)
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
	logger(ctx).Debug("cp: ", src, dst)

	if s.readOnly {
		return fmt.Errorf("cannot write to readonly ipfs driver")
	}
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

	node, err := getNodeFromPath(ctx, s.root(), s.api, src)
	if err != nil {
		return fmt.Errorf("cp: cannot get node from path %s: %s", src, err)
	}
	mkParents := true
	if mkParents {
		err := ensureContainingDirectoryExists(s.root(), dst, nil)
		if err != nil {
			return err
		}
	}

	err = mfs.PutNode(s.root(), dst, node)
	if err != nil {
		return fmt.Errorf("cp: cannot put node in path %s: %s", dst, err)
	}
	flush := true
	if flush {
		_, err := mfs.FlushPath(ctx, s.root(), dst)
		if err != nil {
			return fmt.Errorf("cp: cannot flush the created file %s: %s", dst, err)
		}
	}

	return nil

}

// Writer returns a FileWriter which will store the content written to it
// at the location designated by "path" after the call to Commit.
func (s *IpfsDriver) Writer(ctx context.Context, path string, append bool) (w storagedriver.FileWriter, retErr error) {
	logger(ctx).Debug("Writer: ", path)
	if s.readOnly {
		return nil, fmt.Errorf("cannot write to readonly ipfs driver")
	}

	fi, err := getFileHandleForWriting(s.root(), path, true, nil)
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
		return fmt.Errorf("Close: already closed")
	}
	w.closed = true
	err := w.wfd.Close()
	if err != nil {
		return err
	}
	//	_, err = mfs.FlushPath(w.ctx, w.parent.root, w.path)
	return err
}

// Size returns the number of bytes written to this FileWriter.
func (w *writer) Size() int64 {
	return w.size
}

// Cancel removes any written content from this FileWriter.
func (w *writer) Cancel() error {
	if w.closed {
		return fmt.Errorf("Cancel: already closed")
	} else if w.cancelled {
		return fmt.Errorf("Cancel: already cancelled")
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
	if w.committed {
		return fmt.Errorf("already committed")
	} else if w.closed {
		return fmt.Errorf("already closed")
	} else if w.cancelled {
		return fmt.Errorf("already cancelled")
	}
	w.committed = true
	// close, because we have to (deadlock otherwise)
	// this will also flush.
	return w.Close()
}

// Stat retrieves the FileInfo for the given path, including the current
// size in bytes and the creation time.
func (s *IpfsDriver) Stat(ctx context.Context, path string) (storagedriver.FileInfo, error) {
	logger(ctx).Debug("Stat: ", path)
	fsn, err := s.readonlyLookup(ctx, path)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, storagedriver.PathNotFoundError{Path: path}
		}
		return nil, err
	}

	fi := storagedriver.FileInfoFields{
		Path: path,
	}
	if fsn.Type() == mfs.TDir {
		fi.IsDir = true
	} else {
		nd, err := fsn.GetNode()
		if err != nil {
			return nil, err
		}
		fi.Size, err = sizeNode(nd)
		if err != nil {
			return nil, err
		}
	}

	return storagedriver.FileInfoInternal{FileInfoFields: fi}, nil
}

func sizeNode(nd ipld.Node) (int64, error) {

	cumulsize, err := nd.Size()
	if err != nil {
		return 0, err
	}
	switch n := nd.(type) {
	case *merkledag.ProtoNode:
		d, err := unixfs.FSNodeFromBytes(n.Data())
		if err != nil {
			return 0, err
		}

		return int64(d.FileSize()), nil
	case *merkledag.RawNode:
		return int64(cumulsize), nil
	default:
		return 0, fmt.Errorf("not unixfs node (proto or raw)")
	}
}

// List returns a list of the objects that are direct descendants of the
//given path.
func (s *IpfsDriver) List(ctx context.Context, subPath string) ([]string, error) {
	logger(ctx).Debug("List: ", subPath)
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

	fsn, err := s.readonlyLookup(ctx, path)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, storagedriver.PathNotFoundError{Path: path}
		}
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
		return output, nil

	default:
		return nil, errors.New("not a directory or unrecognized type")
	}
}

// Move moves an object stored at sourcePath to destPath, removing the
// original object.
// Note: This may be no more efficient than a copy followed by a delete for
// many implementations.
func (s *IpfsDriver) Move(ctx context.Context, sourcePath string, destPath string) error {
	logger(ctx).Debug("Move: ", sourcePath, " to ", destPath)
	if s.readOnly {
		return fmt.Errorf("cannot write to readonly ipfs driver")
	}
	flush := true

	src, err := checkPath(sourcePath)
	if err != nil {
		return err
	}
	dst, err := checkPath(destPath)
	if err != nil {
		return err
	}

	err = ensureContainingDirectoryExists(s.root(), dst, nil)
	if err != nil {
		return err
	}

	err = mfs.Mv(s.root(), src, dst)
	if err != nil {
		if os.IsNotExist(err) {
			return storagedriver.PathNotFoundError{Path: sourcePath}
		}
		return err
	}

	if flush {
		_, err = mfs.FlushPath(ctx, s.root(), "/")
	}
	return err
}

// Delete recursively deletes all objects stored at "path" and its subpaths.
func (s *IpfsDriver) Delete(ctx context.Context, path string) error {
	logger(ctx).Debug("Delete: ", path)
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
	logger(ctx).Debug("Walk: ", path)
	return storagedriver.WalkFallback(ctx, s, path, f)
}
