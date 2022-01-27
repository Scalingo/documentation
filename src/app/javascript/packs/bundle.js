/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import docsearch from '@docsearch/js';

// Replace prod url with local/staging/review apps url
function replaceUrl(url) {
  var location = new URL(window.location);
  var newBaseURL = `${location.protocol}//${location.host}/`;
  var prodBaseURL = 'https://doc.scalingo.com/';
  var new_url = url.replace(prodBaseURL, newBaseURL);

  return new_url;
}

["#docsearch-index", "#docsearch-nav"].forEach((container) => {
  docsearch({
    container: container,
    apiKey: '6967a402f012b8a7c4122180616aace0',
    indexName: 'scalingo-doc',
    placeholder: 'Search',
    transformItems(items) {
      return items.map((item) => {
        item.url = replaceUrl(item.url);
        return item;
      });
    },
  });
})
