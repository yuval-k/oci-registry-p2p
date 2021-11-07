To release, do:
```
git tag v<NEXT VERSION HERE>
```

make sure it's not dirty and that the version looks good:

```
make version
```

Build assets in the dist folder, and check-sum them:
```
make images dist/SHA256SUMS.txt
```

Publish to IPFS and create Release readme
```
make publish-ipfs
```

Publish to Github
```
make publish-gh
```