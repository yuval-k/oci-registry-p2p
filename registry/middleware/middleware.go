package middleware

import (
	"context"

	"github.com/distribution/distribution/v3"
	middleware "github.com/distribution/distribution/v3/registry/middleware/repository"
)

func init() {
	middleware.Register("swarm", CreateRepositoryMiddleware)
}

func CreateRepositoryMiddleware(ctx context.Context, repository distribution.Repository, options map[string]interface{}) (distribution.Repository, error) {
	return &swamRepository{Repository: repository}, nil
}

type swamRepository struct {
	distribution.Repository
}

// Manifests returns a reference to this repository's manifest service.
// with the supplied options applied.
func (r *swamRepository) Manifests(ctx context.Context, options ...distribution.ManifestServiceOption) (distribution.ManifestService, error) {
	// get repository name, resolve it in IPFS
	// and get the block store from there
	panic("TODO")
}

// TODO(stevvooe): The above BlobStore return can probably be relaxed to
// be a BlobService for use with clients. This will allow such
// implementations to avoid implementing ServeBlob.

// Tags returns a reference to this repositories tag service
func (r *swamRepository) Tags(ctx context.Context) distribution.TagService {
	// tag service is where we need to deal with IPNS
	// all the rest are blobs
	// get repository name, resolve it in IPFS
	// and get the block store from there
	panic("TODO")
}
