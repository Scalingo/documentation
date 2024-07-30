---
title: Next.js in standalone mode
modified_at: 2024-07-26 11:26:57
tags: nodejs nextjs standalone
index: 5
---
The Next.js built image can be quite large, easily exceeding 500MB. If you encounter issues with the image size, you can try "standalone" mode.

Standalone mode can significantly reduce your image size:
* At the time of writing a fresh Next.js build image is **547MB**,
* A standalone image is **200MB**.

### Enable standalone mode:

#### 1. Add the following to your `next.config.js` file:
```js
module.exports = {
  output: 'standalone',
}
```
or in `next.config.mjs`:
```js
const nextConfig = {
    output: 'standalone',
};
```

#### 2. Add `node_modules` to the `.slugignore` file

This will prevent the `node_modules` directory from being included in the image.


#### 3. Set start script in the package.json

Start the server using Node.js.

```json
{
  "scripts": {
    "start": "node .next/standalone/server.js"
    // others scripts
  }
}
```

{% note %}
Reason: after build node_modules will have been removed, so the original command `next start` will error: `"sh: 1: next: not found"`
{% endnote %}

#### 4. Finally, copy assets

As indicated in the [Next.js documentation](https://nextjs.org/docs/advanced-features/output-file), it doesn't copy assets, so it's up to us to copy them.
To accomplish this, we can create a script that runs at build time to copy the assets to the correct location.

Create a file called `copy-assets.sh` in the root of your project with the following content:
```js
const fs = require('fs').promises;
const path = require('path');

const staticSrcPath = path.join(__dirname, '.next/static');
const staticDestPath = path.join(__dirname, '.next/standalone/.next/static');

const publicSrcPath = path.join(__dirname, 'public');
const publicDestPath = path.join(__dirname, '.next/standalone/public');

function copyAssets(src, dest) {
  return fs.mkdir(dest, { recursive: true })
          .then(() => fs.readdir(src, { withFileTypes: true }))
          .then(items => {
            const promises = items.map(item => {
              const srcPath = path.join(src, item.name);
              const destPath = path.join(dest, item.name);

              if (item.isDirectory()) {
                return copyAssets(srcPath, destPath);
              } else {
                return fs.copyFile(srcPath, destPath);
              }
            });
            return Promise.all(promises);
          })
          .catch(err => {
            console.error(`Error: ${err}`);
            throw err;
          });
}

const greenTick = `\x1b[32m\u2713\x1b[0m`;
const redCross =  `\x1b[31m\u274C\x1b[0m`;
copyAssets(staticSrcPath, staticDestPath)
        .then(() => copyAssets(publicSrcPath, publicDestPath))
        .then(() => console.log(`${greenTick} Assets copied successfully`))
        .catch(err => console.error(`${redCross} Failed to copy assets: ${err}`));
```

Update package.json to run the script at build time:
```json
{
  "scripts": {
    "build": "next build && node copy-assets.js",
    // other scripts
  }
}
```

Your full `scripts` property of your `package.json` should now look like this:
```json
{
  // other properties
  "scripts": {
    "dev": "next dev",
    "build": "next build && node copy-assets.js",
    "start": "node .next/standalone/server.js",
    "lint": "next lint"
  },
  // other properties
}
```

### Sample application

You can find a sample application here: [https://github.com/Scalingo/sample-nextjs-standalone](https://github.com/Scalingo/sample-nextjs-standalone).
