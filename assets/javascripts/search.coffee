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

  slugSection = (section) ->
    return section.toString().toLowerCase()
    .replace(/\s+/g, '-')           # Replace spaces with -
    .replace(/[^\w\-]+/g, '')       # Remove all non-word chars
    .replace(/\-\-+/g, '-')         # Replace multiple - with single -
    .replace(/^-+/, '')             # Trim - from start of text
    .replace(/-+$/, '')             # Trim - from end of text

  $('#st-search-input').swiftypeSearch
    engineKey: 'rQW8Hh49XhMVApNATHZL'
    resultContainingElement: "#search-results"
    renderFunction: (document_type, item) ->
      title = htmlEscape(item.title).split("-", 2)[1]

      hl = item.highlight.body || item.highlight.sections || item.highlight.title
      if !hl
        maxSections = item.sections.length-4
        maxSections = 6 if maxSections > 6
        hl = item.sections.slice(3, maxSections).map((section) ->
          "<a class=\"search-subsection-link\" href=\"#{item.url}\##{slugSection(section)}\">#{section}</a>"
        ).join(" - ")

      '<div class="st-result">
        <h3 class="title no-top">
          <a href="' + item.url + '" class="st-search-result-link">' + title + '</a>
        </h3>
        <p>' + hl + '</p>
      </div>'
    renderPaginationForType: (type, totalPages, currentPage) ->
      pages = '<div class="st-page">'
      if currentPage != 1
        previousPage = currentPage - 1
        pages = pages + '<a href="#" class="st-prev mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" data-hash="true" data-page="' + previousPage + '">previous</a><div class="mdl-layout-spacer"></div>';
      if currentPage < totalPages
        nextPage = currentPage + 1
        pages = pages + '<a href="#" class="st-next mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" data-hash="true" data-page="' + nextPage + '">next</a>';
      pages += '</div>'
      return pages

    preRenderFunction: (data) ->
      $('#st-search-input').get(0).value = ''
      $("#search-modal").modal('show')

  $('#st-search-input').swiftype
    engineKey: 'rQW8Hh49XhMVApNATHZL'
    onRemoteComplete: (data) ->
      spinner.nbRequests -= 1
      spinner.stop()
    beforeRemoteCall: () ->
      spinner.nbRequests += 1
      spinner.start()
