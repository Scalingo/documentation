$ ->
  spinner =
    nbRequests: 0
    isSpinning: false

    start: () ->
      if not @isSpinning
        $("#search-icon").html("<i class=\"fa fa-spinner fa-spin\"></i>")
        @isSpinning = true
    stop: ->
      if @nbRequests == 0
        $("#search-icon").html("<i class=\"fa fa-search\"></i>")
        @isSpinning = false

  $('#st-search-input').swiftype
    engineKey: 'rQW8Hh49XhMVApNATHZL'
    onRemoteComplete: (data) ->
      spinner.nbRequests -= 1
      spinner.stop()
    beforeRemoteCall: () ->
      spinner.nbRequests += 1
      spinner.start()
      
