# Scalingo Documentation

## Running locally

```
bundle
middleman server
```

## Good practice

Think to edit last modification date in the header
of each source file you are editing.

## Deploying in production

```
# -- commit --
# Keep sync branch master
git push origin master

# build html and assets, then deploy on gh-pages branch
middleman deploy
```
