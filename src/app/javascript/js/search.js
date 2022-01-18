var docsearch = require('docsearch.js')
let searchSelector = '#search-input'
let searchNode = document.querySelector(searchSelector)
if (searchNode !== null) {

  let mdcTabBarNode = document.querySelector('.scalingo-toolbar--custom .mdc-tab-bar')

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
    },
    handleSelected: function(input, event, suggestion, datasetNumber, context) {
      // We customize the behaviour of the click on a search result in dev and
      // in review apps.
      if (context.selectionMethod !== 'click') {
        return
      }

      const location = new URL(window.location);
      const newBaseURL = `${location.protocol}//${location.host}/`;
      const prodBaseURL = 'https://doc.scalingo.com/'

      // Replace the domain name doc.scalingo.com with the domain name of the
      // current review app.
      // In production, it replaces doc.scalingo.com with doc.scalingo.com.
      window.location = suggestion.url.replace(prodBaseURL, newBaseURL);
    },
  })
}
