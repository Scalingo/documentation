import * as esbuild from "esbuild";
import postCssPlugin from 'esbuild-style-plugin'
import tailwindcss from '@tailwindcss/postcss';
import autoprefixer from 'autoprefixer';
import postcssImport from 'postcss-import';
import fs from 'fs';

/**
 * @type esbuild.BuildOptions
 */
const opts = {
  entryPoints: [
    "assets/application.js",
    "assets/analytics.js",
    "assets/style.css",
  ],
  entryNames: '[dir]/[name]-[hash]',
  bundle: true,
  minify: true,
  target: ["es2017"],
  outdir: "src/assets",
  plugins: [
    postCssPlugin({
  postcss: {
    plugins: [postcssImport, tailwindcss, autoprefixer]
  },
}),
    {
      name: 'generate-manifest',
      setup(build) {
        build.onEnd(result => {
          // Outputs a file describing the assets produced
          fs.writeFileSync('src/assets/manifest.json', JSON.stringify(result.metafile, null, 2))
          // Touch the `<head>` to ensure jekyll will rebuild
          fs.utimesSync('src/_includes/organisms/head.html', new Date(), new Date());
        })
      },
    }
  ],
  metafile: true,
  logLevel: "info"
};

const lastOpt = process.argv[process.argv.length - 1];

if(lastOpt === "--watch") {
  // This is local development
  opts.sourcemap = true;

  let ctx = await esbuild.context(opts);

  await ctx.watch();
} else {
  await esbuild.build(opts);
}
