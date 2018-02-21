const environment = require('./environment')

console.log("********************************************")
console.log("********************************************")
console.log(JSON.stringify(process.env))
console.log("++++++++++++++++++++++++++++++++++++++++++++")
console.log("++++++++++++++++++++++++++++++++++++++++++++")
console.log(JSON.stringify(environment.toWebpackConfig()))

module.exports = environment.toWebpackConfig()
