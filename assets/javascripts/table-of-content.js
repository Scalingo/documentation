define(['jquery'], function ($) {

  function slugify(s) {
    return s
      .toLowerCase()
      .replace(/[^\w ]+/g,'')
      .replace(/ +/g,'-')
  }

  if (window.location.pathname !== '/404.html' && document.title.indexOf('404 Not found') == -1) {
    var sidebar_nav = $('.sidebar-nav')
    var headers = $('.main-content').find('h2')
    var ul = $('<ul class="collapse show" id="tableOfContent">').addClass('fa-ul mb-0')

    headers.each(function (index, el) {
      // make id from cotent
      var innerText = $(el).text()
      var id = slugify(innerText)

      // inject id
      el.id = id

      var a = $('<a>')
        .attr('href','#' + id)
        .text(innerText)

      a.on("click", function(e){
        $('html, body').animate( { scrollTop: $("#"+id).offset().top }, 600 )
      })

      var li = $('<li>')
        .append('<i class="fa-li fa fa-angle-right"></i>')
        .append(a)

      ul.append(li)
    })

    sidebar_nav.prepend(ul)
    if ($(".fa-ul > li").length > 0) {
      sidebar_nav.prepend('<a class="toc h3" data-toggle="collapse" href="#tableOfContent" aria-expanded="true" aria-controls="tableOfContent">Table of content<span class="fa fa-angle-down" style="margin-top: 2px; right: 36px;"></span></a>')
    }
    else {
      $(".sidebar-nav").css({'border': 'none', 'margin': '0'})
    }
  }

  var $w = $(window);
  $w.on('load resize', function() {
    if ($('.sidebar-nav').width() >= 340) {
      $('.sidebar-nav ul').addClass("show")
      $('.sidebar-nav span').removeClass("fa-angle-down")
    }
    else {
      $('.sidebar-nav ul').removeClass("show")
      $('.sidebar-nav span').addClass("fa-angle-down")
    }
  });

  $('.toc').on("click", function() {
    if ($('.sidebar-nav span').hasClass("fa-angle-down")) {
      $('.sidebar-nav span').removeClass("fa-angle-down")
      $('.sidebar-nav span').addClass("fa-angle-up")
    }
    else {
      $('.sidebar-nav span').removeClass("fa-angle-up")
      $('.sidebar-nav span').addClass("fa-angle-down")
    }
  })
})
