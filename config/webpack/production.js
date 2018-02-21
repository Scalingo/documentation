const environment = require('./environment')

console.log("++++++++++++++++++++++++++++++++++++++++++++")

const { config } = require('@rails/webpacker')
const {
  basename, dirname, join, relative, resolve
} = require('path')
const { sync } = require('glob')

const getExtensionsGlob = () => {
  const { extensions } = config
  return extensions.length === 1 ? `**/*${extensions[0]}` : `**/*{${extensions.join(',')}}`
}

const glob = getExtensionsGlob()

console.log(config.source_path)
console.log(config.source_entry_path)
const rootPath = join(config.source_path, config.source_entry_path)
console.log(rootPath)
const paths = sync(join(rootPath, glob))
console.log(paths)


console.log("++++++++++++++++++++++++++++++++++++++++++++")

module.exports = environment.toWebpackConfig()
