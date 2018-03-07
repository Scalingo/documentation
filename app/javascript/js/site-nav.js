document.addEventListener("DOMContentLoaded", function(event) {

  let navTitles = document.querySelectorAll('.nav-title')
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
    let footer = document.querySelector('footer.realfooter')
    let footerRect = footer.getBoundingClientRect()
    let footerVisible = footerRect.top - window.innerHeight <= 0

    let rect = siteNav.getBoundingClientRect()
    let top = rect.top
    let height = 200
    if (footerVisible) {
      height = footerRect.top - 94 - 40
      siteNav.style.maxHeight = height + "px"
      siteNav.style.position = "fixed"
      siteNav.style.top = "94px"
      siteNav.style.width = "220px"
    } else {
      siteNav.style.removeProperty('position')
      siteNav.style.removeProperty('top')
      siteNav.style.removeProperty('width')
      if (top >= 94) {
        height = window.innerHeight - top
      } else {
        height = rect.bottom - 94
      }
      siteNav.style.maxHeight = height - 20 + "px"
    }
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
