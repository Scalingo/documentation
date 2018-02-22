require('scrollspy-js')

var spy = new ScrollSpy('#article', {
  nav: '.page-nav li > a',
  className: 'active'
})

var scrollToElement = require('scroll-to-element')

document.querySelectorAll('.page-nav a').forEach((el) => {
  el.addEventListener('click', function(e) {
    e.preventDefault()
    let node = e.target
    var targetId = node.getAttribute('href')
    scrollToElement(targetId, {
      offset: -64,
      ease: 'in-out-quad',
      duration: 1000
    })
  })
})
