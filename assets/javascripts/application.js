requirejs.config({
  waitSeconds: 200,
  paths: {
    'jquery': '//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min'
  },
  shim: {
    'bootstrap-modal': ['jquery'],
    'jquery.swiftype.autocomplete': ['jquery'],
    'jquery.swiftype.search': ['jquery'],
    'search': ['jquery', 'jquery.swiftype.autocomplete', 'jquery.swiftype.search', 'bootstrap-modal'],
    'jquery.ba-hashchange.min': ['jquery'],
    'highlight': ['highlight.pack'],
    'anchor': ['jquery', 'table-of-content']
  }
})

requirejs([
  'table-of-content',
  'jquery.ba-hashchange.min',
  'highlight',
  'search',
  'anchor'
  ])
