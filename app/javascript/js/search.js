var docsearch = require('docsearch.js')
let searchSelector = '#search-input'
let searchNode = document.querySelector(searchSelector)
if (searchNode !== null) {
  docsearch({
    apiKey: '6967a402f012b8a7c4122180616aace0',
    indexName: 'scalingo-doc',
    inputSelector: searchSelector,
    debug: true,
    autocompleteOptions: {
      hint: false,
      appendTo: 'body'
    }
  })
}
