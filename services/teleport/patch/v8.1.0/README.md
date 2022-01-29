This patch allow teleprot to use an extra proxy for github auth.

1. clone teleport repo https://github.com/gravitational/teleport
2. checkout to `v8.1.0`:
```
git checkout tags/v8.1.0 -b v8.1.0-add-github-proxy
```
3. apply the patch
```
git am < add-github-proxy-flag.patch
```
4. build on linux server
```
 make full
```
