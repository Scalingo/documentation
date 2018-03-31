var docsearch = require('docsearch.js')
let searchSelector = '#search-input'
let searchNode = document.querySelector(searchSelector)
if (searchNode !== null) {

  let mdcTabBarNode = document.querySelector("header .mdc-toolbar__row + .mdc-toolbar__row .mdc-tab-bar")

  searchNode.addEventListener('focus', (e) => {
    mdcTabBarNode.classList.add('search-expanded')
  })

  searchNode.addEventListener('blur', (e) => {
    mdcTabBarNode.classList.remove('search-expanded')
  })

  docsearch({
    apiKey: '6967a402f012b8a7c4122180616aace0',
    indexName: 'scalingo-doc',
    inputSelector: searchSelector,
    openOnFocus: true,
    autocompleteOptions: {
      hint: false,
      openOnFocus: true,
    }
  })
}
