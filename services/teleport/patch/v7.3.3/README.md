This patch allow teleprot to use an extra proxy for github auth.

1. clone teleport repo https://github.com/gravitational/teleport
2. checkout to `v7.3.3`:
```
git checkout tags/v7.3.3 -b v7.3.3-add-github-proxy
```
3. apply the patch
```
git am < add-github-proxy-flag.patch
```
4. build on linux server
```
make build
```
