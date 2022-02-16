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
  if(document.querySelectorAll(container).length > 0) {
    docsearch({
      container: container,
      appId: 'RWJM2H1BD2',
      apiKey: '9dfb74cc002ece507fac441e93da6345',
      indexName: 'scalingo-doc',
      placeholder: 'Search',
      transformItems(items) {
        return items.map((item) => {
          item.url = replaceUrl(item.url);
          return item;
        });
      },
    });
  }
})
