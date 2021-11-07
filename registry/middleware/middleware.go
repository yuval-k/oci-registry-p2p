package middleware

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strconv"

	"github.com/distribution/distribution/v3"
	"github.com/distribution/distribution/v3/manifest/ocischema"
	"github.com/distribution/distribution/v3/reference"
	middleware "github.com/distribution/distribution/v3/registry/middleware/repository"
	files "github.com/ipfs/go-ipfs-files"
	httpapi "github.com/ipfs/go-ipfs-http-client"
	coreapi "github.com/ipfs/interface-go-ipfs-core"
	ipfspath "github.com/ipfs/interface-go-ipfs-core/path"
	ma "github.com/multiformats/go-multiaddr"
	"github.com/opencontainers/go-digest"
	imgspecv1 "github.com/opencontainers/image-spec/specs-go/v1"
)

func init() {
	middleware.Register("ipfs", CreateRepositoryMiddleware)
}

func CreateRepositoryMiddleware(ctx context.Context, repository distribution.Repository, options map[string]interface{}) (distribution.Repository, error) {

	name := repository.Named().Name()
	location := ipfspath.New("/" + name)
	err := location.IsValid()
	if err != nil {
		// not ipfs, do nothing.
		return repository, nil
	}

	ipfsaddress, ok := options["ipfsapiaddress"]
	if !ok || fmt.Sprint(ipfsaddress) == "" {
		ipfsaddress = "/ip4/127.0.0.1/tcp/5001"
	}

	addr, err := ma.NewMultiaddr(fmt.Sprint(ipfsaddress))
	if err != nil {
		return nil, err
	}
	api, err := httpapi.NewApi(addr)
	if err != nil {
		return nil, err
	}
	return newIpfsRepository(api, location, repository.Named()), nil
}

var _ distribution.Repository = &ipfsRepository{}

type ipfsRepository struct {
	api      coreapi.CoreAPI
	location ipfspath.Path
	ref      reference.Named

	unixfs coreapi.UnixfsAPI
}

func newIpfsRepository(api coreapi.CoreAPI, location ipfspath.Path, ref reference.Named) *ipfsRepository {
	return &ipfsRepository{
		api:      api,
		location: location,
		ref:      ref,
		unixfs:   api.Unixfs(),
	}
}

func (r *ipfsRepository) Named() reference.Named {
	return r.ref
}

// Manifests returns a reference to this repository's manifest service.
// with the supplied options applied.
func (r *ipfsRepository) Manifests(ctx context.Context, options ...distribution.ManifestServiceOption) (distribution.ManifestService, error) {
	// get repository name, resolve it in IPFS
	// and get the block store from there
	return &manifestService{
		parent: r,
	}, nil
}

// Tags returns a reference to this repositories tag service
func (r *ipfsRepository) Tags(ctx context.Context) distribution.TagService {
	return &tagService{
		parent: r,
	}
}

// Blobs returns a reference to this repository's blob service.
func (r *ipfsRepository) Blobs(ctx context.Context) distribution.BlobStore {
	return &blobStore{
		parent: r,
	}
}

func (r *ipfsRepository) digestPath(dgst digest.Digest) ipfspath.Path {
	return ipfspath.Join(r.location, "blobs", dgst.Algorithm().String(), dgst.Encoded())
}

type tagService struct {
	parent *ipfsRepository
}

type manifestService struct {
	parent *ipfsRepository
}
type blobStore struct {
	parent *ipfsRepository
}

const blobContentType = "application/octet-stream"

var _ distribution.BlobStore = &blobStore{}
var _ distribution.ManifestService = &manifestService{}
var _ distribution.TagService = &tagService{}

// BlobStatter makes blob descriptors available by digest. The service may
// provide a descriptor of a different digest if the provided digest is not
// canonical.

// Stat provides metadata about a blob identified by the digest. If the
// blob is unknown to the describer, ErrBlobUnknown will be returned.
func (b *blobStore) Stat(ctx context.Context, dgst digest.Digest) (distribution.Descriptor, error) {
	f, err := b.getBlob(ctx, dgst)
	if err != nil {
		return distribution.Descriptor{}, err
	}
	defer f.Close()
	size, err := f.Size()
	if err != nil {
		return distribution.Descriptor{}, err
	}
	return distribution.Descriptor{
		MediaType: blobContentType,
		Size:      size,
		Digest:    dgst,
	}, nil
}

// BlobDeleter enables deleting blobs from storage.
func (b *blobStore) Delete(ctx context.Context, dgst digest.Digest) error {
	return distribution.ErrUnsupported
}

// BlobProvider describes operations for getting blob data.
// Get returns the entire blob identified by digest along with the descriptor.
func (b *blobStore) Get(ctx context.Context, dgst digest.Digest) ([]byte, error) {
	f, err := b.getBlob(ctx, dgst)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return io.ReadAll(f)
}

// Open provides a ReadSeekCloser to the blob identified by the provided
// descriptor. If the blob is not known to the service, an error will be
// returned.
func (b *blobStore) Open(ctx context.Context, dgst digest.Digest) (distribution.ReadSeekCloser, error) {
	return b.getBlob(ctx, dgst)
}

func (b *blobStore) getBlob(ctx context.Context, dgst digest.Digest) (files.File, error) {
	blob := b.parent.digestPath(dgst)
	n, err := b.parent.unixfs.Get(ctx, blob)
	if err != nil {
		if os.IsNotExist(err) {
			return nil, distribution.ErrBlobUnknown
		}
		return nil, err
	}
	file, ok := n.(files.File)
	if !ok {
		n.Close()
		return nil, fmt.Errorf("unexpected node type")
	}
	return file, nil
}

// BlobServer can serve blobs via http.
// ServeBlob attempts to serve the blob, identified by dgst, via http. The
// service may decide to redirect the client elsewhere or serve the data
// directly.
//
// This handler only issues successful responses, such as 2xx or 3xx,
// meaning it serves data or issues a redirect. If the blob is not
// available, an error will be returned and the caller may still issue a
// response.
//
// The implementation may serve the same blob from a different digest
// domain. The appropriate headers will be set for the blob, unless they
// have already been set by the caller.
func (b *blobStore) ServeBlob(ctx context.Context, w http.ResponseWriter, r *http.Request, dgst digest.Digest) error {
	file, err := b.getBlob(ctx, dgst)
	if err != nil {
		return err
	}

	size, _ := file.Size()

	w.Header().Set("Content-Length", strconv.FormatInt(size, 10))
	w.Header().Set("Content-Type", blobContentType)
	w.Header().Set("Etag", dgst.String())

	if r.Method == http.MethodHead {
		return nil
	}

	io.CopyN(w, file, size)
	return nil
}

// BlobIngester ingests blob data.

// Put inserts the content p into the blob service, returning a descriptor
// or an error.
func (b *blobStore) Put(ctx context.Context, mediaType string, p []byte) (distribution.Descriptor, error) {
	return distribution.Descriptor{}, distribution.ErrUnsupported
}

// Create allocates a new blob writer to add a blob to this service. The
// returned handle can be written to and later resumed using an opaque
// identifier. With this approach, one can Close and Resume a BlobWriter
// multiple times until the BlobWriter is committed or cancelled.
func (b *blobStore) Create(ctx context.Context, options ...distribution.BlobCreateOption) (distribution.BlobWriter, error) {
	return nil, distribution.ErrUnsupported
}

// Resume attempts to resume a write to a blob, identified by an id.
func (b *blobStore) Resume(ctx context.Context, id string) (distribution.BlobWriter, error) {
	return nil, distribution.ErrUnsupported
}

// Exists returns true if the manifest exists.
func (m *manifestService) Exists(ctx context.Context, dgst digest.Digest) (bool, error) {
	blob := m.parent.digestPath(dgst)
	n, err := m.parent.unixfs.Get(ctx, blob)
	if err == nil {
		return true, nil
	}
	n.Close()
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

// Get retrieves the manifest specified by the given digest
func (m *manifestService) Get(ctx context.Context, dgst digest.Digest, options ...distribution.ManifestServiceOption) (distribution.Manifest, error) {

	content, err := m.parent.Blobs(ctx).Get(ctx, dgst)
	if err != nil {
		return nil, err
	}

	manifest := &imgspecv1.Manifest{}
	if err := json.NewDecoder(bytes.NewBuffer(content)).Decode(manifest); err != nil {
		return nil, err
	}
	if manifest.SchemaVersion != 2 {
		return nil, fmt.Errorf("unexpected schema version")
	}

	dm := &ocischema.DeserializedManifest{}
	if err := dm.UnmarshalJSON(content); err != nil {
		return nil, err
	}
	return dm, nil

}

// Put creates or updates the given manifest returning the manifest digest
func (m *manifestService) Put(ctx context.Context, manifest distribution.Manifest, options ...distribution.ManifestServiceOption) (digest.Digest, error) {
	return digest.Digest(""), fmt.Errorf("read only registry")
}

// Delete removes the manifest specified by the given digest. Deleting
// a manifest that doesn't exist will return ErrManifestNotFound
func (m *manifestService) Delete(ctx context.Context, dgst digest.Digest) error {
	return fmt.Errorf("read only registry")
}

// Get retrieves the descriptor identified by the tag. Some
// implementations may differentiate between "trusted" tags and
// "untrusted" tags. If a tag is "untrusted", the mapping will be returned
// as an ErrTagUntrusted error, with the target descriptor.
func (t *tagService) Get(ctx context.Context, tag string) (distribution.Descriptor, error) {
	var ret distribution.Descriptor
	index, err := t.getIndex(ctx)
	if err != nil {
		return ret, err
	}

	for _, manifest := range index.Manifests {
		if manifest.MediaType != imgspecv1.MediaTypeImageManifest {
			continue
		}
		if manifest.Annotations != nil {
			if tag == manifest.Annotations[imgspecv1.AnnotationRefName] {
				ret.Annotations = manifest.Annotations
				ret.Digest = manifest.Digest
				ret.MediaType = manifest.MediaType
				ret.Size = manifest.Size
				ret.Platform = manifest.Platform
				ret.URLs = manifest.URLs

				return ret, nil
			}
		}
	}
	return ret, distribution.ErrTagUnknown{Tag: tag}
}

// Tag associates the tag with the provided descriptor, updating the
// current association, if needed.
func (t *tagService) Tag(ctx context.Context, tag string, desc distribution.Descriptor) error {
	return fmt.Errorf("read only registry")
}

// Untag removes the given tag association
func (t *tagService) Untag(ctx context.Context, tag string) error {
	return fmt.Errorf("read only registry")
}

// All returns the set of tags managed by this tag service
func (t *tagService) All(ctx context.Context) ([]string, error) {
	return t.Lookup(ctx, distribution.Descriptor{})
}

func (t *tagService) getIndex(ctx context.Context) (*imgspecv1.Index, error) {
	r := t.parent
	path := ipfspath.Join(r.location, "index.json")

	node, err := r.unixfs.Get(ctx, path)
	if err != nil {
		return nil, err
	}
	defer node.Close()

	file, ok := node.(files.File)
	if !ok {
		return nil, fmt.Errorf("unexpected node type")
	}

	index := &imgspecv1.Index{}
	if err := json.NewDecoder(file).Decode(index); err != nil {
		return nil, err
	}
	return index, nil
}

// Lookup returns the set of tags referencing the given digest.
func (t *tagService) Lookup(ctx context.Context, digest distribution.Descriptor) ([]string, error) {
	index, err := t.getIndex(ctx)
	if err != nil {
		return nil, err
	}
	var res []string
	for _, manifest := range index.Manifests {
		if manifest.MediaType != imgspecv1.MediaTypeImageManifest {
			continue
		}
		ref := ""
		if manifest.Annotations != nil {
			ref = manifest.Annotations[imgspecv1.AnnotationRefName]
		}
		if ref != "" {
			if len(digest.Digest) == 0 || manifest.Digest == digest.Digest {
				res = append(res, ref)
			}
		}
	}

	return res, nil
}
