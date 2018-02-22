var docsearch = require('docsearch.js')

docsearch({
  apiKey: '6967a402f012b8a7c4122180616aace0',
  indexName: 'scalingo-doc',
  inputSelector: '#search-input',
  debug: true,
  autocompleteOptions: {
    hint: false,
    appendTo: 'body'
  }
})
