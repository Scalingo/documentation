const environment = require('./environment')
const ExtractTextPlugin = require("extract-text-webpack-plugin");

environment.config.set('output.filename', '[name].js')

environment.plugins.append('ExtractText2', new ExtractTextPlugin('[name].css'))

module.exports = environment.toWebpackConfig()
