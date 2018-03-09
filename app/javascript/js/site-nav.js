function collapseSection(element) {
  // get the height of the element's inner content, regardless of its actual size
  var sectionHeight = element.scrollHeight;

  // temporarily disable all css transitions
  var elementTransition = element.style.transition;
  element.style.transition = '';

  // on the next frame (as soon as the previous style change has taken effect),
  // explicitly set the element's height to its current pixel height, so we
  // aren't transitioning out of 'auto'
  requestAnimationFrame(function() {
    element.style.height = sectionHeight + 'px';
    element.style.transition = elementTransition;

    // on the next frame (as soon as the previous style change has taken effect),
    // have the element transition to height: 0
    requestAnimationFrame(function() {
      element.style.height = 0 + 'px';
    });
  });

  // mark the section as "currently collapsed"
  // element.setAttribute('data-collapsed', 'true');
}

function expandSection(element) {
  // get the height of the element's inner content, regardless of its actual size
  var sectionHeight = element.scrollHeight;

  // have the element transition to the height of its inner content
  element.style.height = sectionHeight + 'px';

  // when the next css transition finishes (which should be the one we just triggered)
  element.addEventListener('transitionend', function(e) {
    // remove this event listener so it only gets triggered once
    element.removeEventListener('transitionend', arguments.callee);

    // remove "height" from the element's inline styles, so it can return to its initial value
    element.style.height = null;
  });

  // mark the section as "currently not collapsed"
  // element.setAttribute('data-collapsed', 'false');
}

document.addEventListener("DOMContentLoaded", function(event) {

  let navTitles = document.querySelectorAll('.nav-title')
  navTitles.forEach((element) => {
    element.addEventListener('click', (e) => {
      e.preventDefault()
      let node = e.target
      let parent = node.parentElement
      let currentState = parent.getAttribute('data-state')
      let isCollapsed = currentState == 'closed'
      let section = parent.querySelector('ul')
      if(isCollapsed) {
        expandSection(section)
        parent.setAttribute('data-state', 'open')
      } else {
        collapseSection(section)
        parent.setAttribute('data-state', 'closed')
      }
    })
  })

  function manageSiteNav(siteNavNode, mainNode, mainHeight) {
    let mainRect = mainNode.getBoundingClientRect()

    let articleBottomVisible = (mainRect.bottom - window.innerHeight) <= 0
    let articleTopVisible = (mainRect.top > 94) && (mainRect.top < window.innerHeight)

    let height = 200

    let siteNavHeight = siteNavNode.offsetHeight

    if (mainHeight > siteNavHeight) {
      if (articleBottomVisible && !articleTopVisible) {
        height = mainRect.bottom - 94
        siteNavNode.style.height = height + "px"
        siteNavNode.style.position = "fixed"
        siteNavNode.style.top = "94px"
        siteNavNode.style.width = "220px"
      } else {
        siteNavNode.style.removeProperty('position')
        siteNavNode.style.removeProperty('top')
        siteNavNode.style.removeProperty('width')

        let siteNavRect = siteNavNode.getBoundingClientRect()
        let siteNavTop = siteNavRect.top

        if (siteNavTop >= 94) {
          height = window.innerHeight - siteNavTop
        } else {
          height = siteNavRect.bottom - 94
        }
        siteNavNode.style.height = height - 20 + "px"
      }
    }
  }

  let siteNavNode = document.querySelector('.site-nav > nav')
  let mainNode = document.querySelector('main')
  if (siteNavNode !== null && mainNode !== null) {
    let mainHeight = mainNode.offsetHeight
    window.addEventListener('scroll', function(ev) {
      manageSiteNav(siteNavNode, mainNode, mainHeight)
    })
    window.addEventListener('resize', function(ev) {
      manageSiteNav(siteNavNode, mainNode, mainHeight)
    })
    manageSiteNav(siteNavNode, mainNode, mainHeight)
  }

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
  if (activeLink !== null && siteNavNode !== null) {
    scrollIfNeeded(activeLink, siteNavNode)
  }
})
