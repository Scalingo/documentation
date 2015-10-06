---
---

$ ->
  searchIcon = $("#search-icon")
  spinner =
    nbRequests: 0
    isSpinning: false

    start: () ->
      if not @isSpinning
        searchIcon.removeClass("fa-search")
        searchIcon.addClass("fa-spinner fa-spin")
        @isSpinning = true
    stop: ->
      if @nbRequests == 0
        searchIcon.addClass("fa-search")
        searchIcon.removeClass("fa-spinner fa-spin")
        @isSpinning = false

  htmlEscape = (str) ->
    return String(str).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;').replace(/>/g, '&gt;')

  $('#st-search-input').swiftypeSearch
    engineKey: 'rQW8Hh49XhMVApNATHZL'
    resultContainingElement: "#search-results"
    renderFunction: (document_type, item) ->
      title = htmlEscape(item.title).split("-", 2)[1]
      hl = item.highlight.body || item.highlight.sections || item.highlight.title
      '<div class="st-result">
        <h3 class="title no-top">
          <a href="' + item.url + '" class="st-search-result-link">' + title + '</a>
        </h3>
        <p>' + hl + '</p>
      </div>'

    preRenderFunction: (data) ->
      $("#search-modal").modal('show')

  $('#st-search-input').swiftype
    engineKey: 'rQW8Hh49XhMVApNATHZL'
    onRemoteComplete: (data) ->
      spinner.nbRequests -= 1
      spinner.stop()
    beforeRemoteCall: () ->
      spinner.nbRequests += 1
      spinner.start()
