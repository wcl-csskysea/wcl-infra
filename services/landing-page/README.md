1. cd to this folder
1. update site data `data/sites.yaml`
1. mount the image assets:
```
git worktree add -B assets-images-for-landing-page  themes/devops-landing-page/static/assets/images  origin/assets-images-for-landing-page
```
1. `hugo server` or `hugo build`

