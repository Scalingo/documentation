import * as esbuild from "esbuild";
import postCssPlugin from 'esbuild-style-plugin'
import tailwindcss from 'tailwindcss';
import autoprefixer from 'autoprefixer';
import postcssImport from 'postcss-import';
import fs from 'fs';

/**
 * @type esbuild.BuildOptions
 */
const opts = {
  entryPoints: [
    "assets/application.js",
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
        plugins: [tailwindcss, autoprefixer, postcssImport]
      },
    }),
    {
      name: 'generate-manifest',
      setup(build) {
        build.onEnd(result => {
          fs.writeFileSync('assets/manifest.json', JSON.stringify(result.metafile, null, 2))
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
