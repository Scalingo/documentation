document.addEventListener("DOMContentLoaded", function(event) {

  let navTitles = document.querySelectorAll('li:not([data-type=\'link\']) .nav-title')
  navTitles.forEach((element) => {
    element.addEventListener('click', (e) => {
      e.preventDefault()
      let node = e.target
      let parent = node.parentElement
      let currentState = parent.getAttribute('data-state')
      if (currentState == 'open') {
        parent.setAttribute('data-state', 'closed')
      } else {
        parent.setAttribute('data-state', 'open')
      }
    })
  })

  function computeSiteNavHeight(siteNav) {
    let rect = siteNav.getBoundingClientRect()
    let top = rect.top
    let height = 200
    if (top >= 94) {
      height = window.innerHeight - top
    } else {
      height = rect.bottom - 94
    }
    siteNav.style.height = height - 20 + "px"
  }

  let siteNav = document.querySelector('.site-nav > nav')
  if (siteNav !== null) {
    window.addEventListener('scroll', function(ev) {
      computeSiteNavHeight(siteNav)
    })
    window.addEventListener('resize', function(ev) {
      computeSiteNavHeight(siteNav)
    })
  }
  computeSiteNavHeight(siteNav)

  function scrollIfNeeded(element, container) {
    if (element.offsetTop < container.scrollTop) {
      container.scrollTop = element.offsetTop
    } else {
      const offsetBottom = element.offsetTop + element.offsetHeight
      const scrollBottom = container.scrollTop + container.offsetHeight
      if (offsetBottom > scrollBottom) {
        container.scrollTop = offsetBottom - container.offsetHeight
      }
    }
  }

  let activeLink = document.querySelector('.site-nav a.active')
  if (activeLink !== null && siteNav !== null) {
    scrollIfNeeded(activeLink, siteNav)
  }
})
