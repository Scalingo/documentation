process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')

environment.config.set('output.filename', '[name].js')

environment.plugins.insert(
  'MiniCssExtract',
  new MiniCssExtractPlugin({
    filename: 'css/[name].css',
    chunkFilename: 'css/[name].chunk.css'
  })
)

module.exports = environment.toWebpackConfig()
