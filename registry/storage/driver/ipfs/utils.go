package ipfs

import (
	"context"
	"errors"
	"fmt"
	"os"
	gopath "path"
	"strings"

	"github.com/ipfs/go-cid"
	ipld "github.com/ipfs/go-ipld-format"
	dag "github.com/ipfs/go-merkledag"
	"github.com/ipfs/go-mfs"
	ft "github.com/ipfs/go-unixfs"
	iface "github.com/ipfs/interface-go-ipfs-core"
	path "github.com/ipfs/interface-go-ipfs-core/path"
)

func getFileHandleForWriting(r *mfs.Root, path string, create bool, builder cid.Builder) (*mfs.File, error) {

	ensureContainingDirectoryExists(r, path, builder)

	target, err := mfs.Lookup(r, path)
	switch err {
	case nil:
		fi, ok := target.(*mfs.File)
		if !ok {
			return nil, fmt.Errorf("%s was not a file", path)
		}
		return fi, nil

	case os.ErrNotExist:
		if !create {
			return nil, err
		}

		// if create is specified and the file doesn't exist, we create the file
		dirname, fname := gopath.Split(path)
		pdir, err := getParentDir(r, dirname)
		if err != nil {
			return nil, err
		}

		if builder == nil {
			builder = pdir.GetCidBuilder()
		}

		nd := dag.NodeWithData(ft.FilePBData(nil, 0))
		nd.SetCidBuilder(builder)
		err = pdir.AddChild(fname, nd)
		if err != nil {
			return nil, err
		}

		fsn, err := pdir.Child(fname)
		if err != nil {
			return nil, err
		}

		fi, ok := fsn.(*mfs.File)
		if !ok {
			return nil, errors.New("expected *mfs.File, didn't get it. This is likely a race condition")
		}
		return fi, nil

	default:
		return nil, err
	}
}

func checkPath(p string) (string, error) {
	if len(p) == 0 {
		return "", fmt.Errorf("paths must not be empty")
	}

	if p[0] != '/' {
		return "", fmt.Errorf("paths must start with a leading slash")
	}

	cleaned := gopath.Clean(p)
	if p[len(p)-1] == '/' && p != "/" {
		cleaned += "/"
	}
	return cleaned, nil
}

func getParentDir(root *mfs.Root, dir string) (*mfs.Directory, error) {
	parent, err := mfs.Lookup(root, dir)
	if err != nil {
		return nil, err
	}

	pdir, ok := parent.(*mfs.Directory)
	if !ok {
		return nil, errors.New("expected *mfs.Directory, didn't get it. This is likely a race condition")
	}
	return pdir, nil
}

func ensureContainingDirectoryExists(r *mfs.Root, path string, builder cid.Builder) error {
	dirtomake := gopath.Dir(path)

	if dirtomake == "/" {
		return nil
	}

	return mfs.Mkdir(r, dirtomake, mfs.MkdirOpts{
		Mkparents:  true,
		CidBuilder: builder,
	})
}

func getNodeFromPath(ctx context.Context, filesRoot *mfs.Root, api iface.CoreAPI, p string) (ipld.Node, error) {
	switch {
	case strings.HasPrefix(p, "/ipfs/"):
		return api.ResolveNode(ctx, path.New(p))
	default:
		fsn, err := mfs.Lookup(filesRoot, p)
		if err != nil {
			return nil, err
		}

		return fsn.GetNode()
	}
}
