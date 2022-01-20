const { environment, config } = require('@rails/webpacker')
const { resolve } = require('path')

const source_path = config.source_path

environment.config.set('output.path', resolve('_site', config.public_output_path))

environment.loaders.get('sass').use.find(item => item.loader === 'sass-loader').options.includePaths = ['node_modules']

// exclude 'svg' from file loader
const fileLoader = environment.loaders.get('file')
fileLoader.test = /\.(jpg|jpeg|png|gif|ico|eot|otf|ttf|woff|woff2)$/i

// Specify enforce: 'pre' to apply the loader
// before url-loader/svg-url-loader
// and not duplicate it in rules with them
environment.loaders.append('image-webpack-loader', {
  test: /\.(jpg|jpeg|png|gif)$/,
  loader: 'image-webpack-loader',
  options: {
    bypassOnDebug: true,
  },
  enforce: 'pre'
})

environment.loaders.append('svg-no-sprite', {
  test: /(about|blog)\/(.*)\.svg$/,
  use: [
    {
      loader: 'file-loader', options: {
        name: '[path][name]-[hash].[ext]',
        context: source_path
      }
    },
    {
      loader: 'svgo-loader', options: {
        plugins: [
          {cleanupIDs: false},
          {removeViewBox: false},
          {removeDimensions: true}
        ]
      }
    }
  ]
})

module.exports = environment
