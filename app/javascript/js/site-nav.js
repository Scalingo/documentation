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

  // function manageSiteNav(siteNavNode, mainNode, mainHeight) {
  //   let mainRect = mainNode.getBoundingClientRect()

  //   let articleBottomVisible = (mainRect.bottom - window.innerHeight) <= 0
  //   let articleTopVisible = (mainRect.top > 94) && (mainRect.top < window.innerHeight)

  //   let height = 200

  //   let siteNavHeight = siteNavNode.offsetHeight

  //   if (mainHeight > siteNavHeight) {
  //     if (articleBottomVisible && !articleTopVisible) {
  //       height = mainRect.bottom - 94
  //       siteNavNode.style.height = height + "px"
  //       siteNavNode.style.position = "fixed"
  //       siteNavNode.style.top = "94px"
  //       siteNavNode.style.width = "220px"
  //     } else {
  //       siteNavNode.style.removeProperty('position')
  //       siteNavNode.style.removeProperty('top')
  //       siteNavNode.style.removeProperty('width')

  //       let siteNavRect = siteNavNode.getBoundingClientRect()
  //       let siteNavTop = siteNavRect.top

  //       if (siteNavTop >= 94) {
  //         height = window.innerHeight - siteNavTop
  //       } else {
  //         height = siteNavRect.bottom - 94
  //       }
  //       siteNavNode.style.height = height - 20 + "px"
  //     }
  //   }
  // }

  // Detect css transform
  var cssTransform = (function(){
      var prefixes = 'transform webkitTransform mozTransform oTransform msTransform'.split(' ')
        , el = document.createElement('div')
        , cssTransform
        , i = 0
      while( cssTransform === undefined ){
          cssTransform = document.createElement('div').style[prefixes[i]] != undefined ? prefixes[i] : undefined
          i++
       }
       return cssTransform
  })()

  var scroll = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || function(callback){ window.setTimeout(callback, 1000/60) }
  var has3d = document.body.style.transform

  var siteNavNode = document.querySelector('.site-nav > nav')
  var articleNode = document.querySelector('article')

  var siteNavBottomMargin = 20
  var mainMargin = 40

  var windowInnerHeight, siteNavMaxHeight, lastPosition = -1
  var articleRect, articleTop, articleBottom, articleBottomWithMargin, articleHeight

  function computeSizes() {
    lastPosition = -1
    windowInnerHeight = window.innerHeight

    articleRect = articleNode.getBoundingClientRect()
    articleTop = articleRect.top + window.pageYOffset - 94
    articleBottom = articleTop + articleNode.offsetHeight
    articleBottomWithMargin = articleBottom + mainMargin - windowInnerHeight + 94
    articleHeight = articleNode.offsetHeight
    siteNavMaxHeight = windowInnerHeight - 94 - siteNavBottomMargin
  }

  function loop(){
    // Avoid calculations if not needed
    if (lastPosition == window.pageYOffset) {
      scroll(loop)
      return false
    } else lastPosition = window.pageYOffset

    if (lastPosition <= articleTop) {
      // top of page above article top
      siteNavNode.style.position = "sticky"
      siteNavNode.style.height = windowInnerHeight - (articleTop - lastPosition + 94) - siteNavBottomMargin + "px"
    } else {
      if (lastPosition <= articleBottomWithMargin) {
        // Between article top and article bottom
        if (siteNavNode.style.height != siteNavMaxHeight) {
          // We've already set the infos
          siteNavNode.style.position = "sticky"
          siteNavNode.style.height = siteNavMaxHeight + "px"
        }
      } else {
        // Towards bottom of page
        siteNavNode.style.position = "fixed"
        siteNavNode.style.height = windowInnerHeight - (lastPosition + windowInnerHeight - articleBottom) + siteNavBottomMargin + "px"
      }
    }

    scroll(loop)
  }

  window.onresize = computeSizes

  computeSizes()
  loop()

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
