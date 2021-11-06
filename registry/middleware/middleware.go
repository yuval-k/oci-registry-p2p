package middleware

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"

	"github.com/distribution/distribution/v3"
	"github.com/distribution/distribution/v3/reference"
	middleware "github.com/distribution/distribution/v3/registry/middleware/repository"
	files "github.com/ipfs/go-ipfs-files"
	httpapi "github.com/ipfs/go-ipfs-http-client"
	coreapi "github.com/ipfs/interface-go-ipfs-core"
	ipfspath "github.com/ipfs/interface-go-ipfs-core/path"
	ma "github.com/multiformats/go-multiaddr"
	imgspecv1 "github.com/opencontainers/image-spec/specs-go/v1"
)

func init() {
	middleware.Register("ipfs", CreateRepositoryMiddleware)
}

func CreateRepositoryMiddleware(ctx context.Context, repository distribution.Repository, options map[string]interface{}) (distribution.Repository, error) {
	if strings.Contains(repository.Named().String(), "/ipfs/") {
		parts := strings.Split(repository.Named().String(), "/ipfs/")
		if len(parts) != 2 {
			return nil, fmt.Errorf("invalid ipfs reference")
		}
		location := parts[1]

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

	return repository, nil
}

var _ distribution.Repository = &ipfsRepository{}

type ipfsRepository struct {
	api      coreapi.CoreAPI
	location string
	ref      reference.Named

	unixfs coreapi.UnixfsAPI
}

func newIpfsRepository(api coreapi.CoreAPI, location string, ref reference.Named) *ipfsRepository {
	return &ipfsRepository{
		api:      api,
		location: location,
		ref:      ref,
		unixfs:   api.Unixfs(),
	}
}

// Manifests returns a reference to this repository's manifest service.
// with the supplied options applied.
func (r *ipfsRepository) Manifests(ctx context.Context, options ...distribution.ManifestServiceOption) (distribution.ManifestService, error) {
	// get repository name, resolve it in IPFS
	// and get the block store from there
	panic("TODO")
}

// Tags returns a reference to this repositories tag service
func (r *ipfsRepository) Tags(ctx context.Context) distribution.TagService {
	return &tagService{
		parent: r,
	}
}

func (r *ipfsRepository) Named() reference.Named {
	return r.ref
}

// Blobs returns a reference to this repository's blob service.
func (r *ipfsRepository) Blobs(ctx context.Context) distribution.BlobStore {
	panic("TODO")
}

type tagService struct {
	parent *ipfsRepository
}

var _ distribution.TagService = &tagService{}

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
			res = append(res, ref)
		}
	}

	return res, nil
}

func (t *tagService) getIndex(ctx context.Context) (*imgspecv1.Index, error) {
	r := t.parent
	path := ipfspath.New(r.location)
	path = ipfspath.Join(path, "index.json")

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
	panic("not implemented") // TODO: Implement
}
