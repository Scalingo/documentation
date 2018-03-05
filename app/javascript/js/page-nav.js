require('scrollspy-js')
const scrollToElement = require('scroll-to-element')

document.addEventListener("DOMContentLoaded", function(event) {
  var article = document.getElementById('article')
  if (article !== null) {
    var spy = new ScrollSpy('#article', {
      nav: '.page-nav li > a',
      className: 'active'
    })
  }

  document.querySelectorAll('.page-nav a').forEach((el) => {
    el.addEventListener('click', function(e) {
      e.preventDefault()
      let node = e.target
      var targetId = node.getAttribute('href')
      location.hash = targetId
      scrollToElement(targetId, {
        offset: -64,
        ease: 'in-out-quad',
        duration: 500
      })
    })
  })
})
