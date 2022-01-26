/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import docsearch from '@docsearch/js';

docsearch({
  container: '#docsearch-nav',
  apiKey: '6967a402f012b8a7c4122180616aace0',
  indexName: 'scalingo-doc',
  placeholder: 'Search',
});

docsearch({
  container: '#docsearch-index',
  apiKey: '6967a402f012b8a7c4122180616aace0',
  indexName: 'scalingo-doc',
  placeholder: 'Search',
});
