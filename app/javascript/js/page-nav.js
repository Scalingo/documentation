(function() {
  'use strict'

  var section = document.querySelectorAll("article h2, article h3")
  var sections = {}
  var i = 0

  Array.prototype.forEach.call(section, function(e) {
    sections[e.id] = e.offsetTop
  })

  window.onscroll = function() {
    var scrollPosition = document.documentElement.scrollTop || document.body.scrollTop

    for (i in sections) {
      if (sections[i] <= (scrollPosition + 64)) {
        let activeLink = document.querySelector('.page-nav li > a.active')
        if (activeLink !== null) {
          activeLink.setAttribute('class', ' ')
        }
        document.querySelector('.page-nav li > a[href*=' + i + ']').setAttribute('class', 'active')
      }
    }
  }
})()

import SmoothScroll from 'smooth-scroll'

let scroll = new SmoothScroll(".page-nav a")
