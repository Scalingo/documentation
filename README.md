# Scalingo Documentation

## Running locally

```
bundle
middleman server
```

## Deploying in production

```
# -- commit --
# Keep sync branch master
git push origin master

# build html and assets, then deploy on gh-pages branch
middleman deploy
```
