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

let navTitles = document.querySelectorAll('.nav-title')
navTitles.forEach((element) => {
  element.addEventListener('click', (e) => {
    e.preventDefault()
    let node = e.currentTarget
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

var scroll = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || function(callback){ window.setTimeout(callback, 1000/60) }

var headerNode = document.querySelector('header')
var siteNavNode = document.querySelector('.site-nav > nav')
var pageNavNode = document.querySelector('.page-nav > nav')
var mainNode = document.querySelector('main')

var siteNavBottomMargin = 20
var mainMargin = 40

var windowInnerHeight, siteNavMaxHeight, lastPosition = -1
var articleRect, articleTop, articleBottom, articleBottomWithMargin, articleHeight
var headerHeightPlusMargin = headerNode.offsetHeight + 30

function computeSizes() {
  lastPosition = -1
  windowInnerHeight = window.innerHeight

  headerHeightPlusMargin = headerNode.offsetHeight + 30
  articleRect = mainNode.getBoundingClientRect()
  articleTop = articleRect.top + window.pageYOffset - headerHeightPlusMargin
  articleBottom = articleTop + mainNode.offsetHeight
  articleBottomWithMargin = articleBottom + mainMargin - windowInnerHeight + headerHeightPlusMargin
  articleHeight = mainNode.offsetHeight
  siteNavMaxHeight = windowInnerHeight - headerHeightPlusMargin - siteNavBottomMargin
}

function loop(){
  if (articleHeight >= siteNavMaxHeight) {
    // Avoid calculations if not needed
    if (lastPosition == window.pageYOffset) {
      scroll(loop)
      return false
    } else lastPosition = window.pageYOffset

    if (lastPosition <= articleTop) {
      // top of page above article top
      siteNavNode.style.position = "sticky"
      siteNavNode.style.top = headerHeightPlusMargin + "px"
      if (pageNavNode !== null) {
        pageNavNode.style.top = headerHeightPlusMargin + "px"
      }
      siteNavNode.style.height = windowInnerHeight - (articleTop - lastPosition + headerHeightPlusMargin) - siteNavBottomMargin + "px"
    } else {
      if (lastPosition <= articleBottomWithMargin) {
        // Between article top and article bottom
        if (siteNavNode.style.height != siteNavMaxHeight) {
          // We've already set the infos
          siteNavNode.style.position = "sticky"
          siteNavNode.style.top = headerHeightPlusMargin + "px"
          if (pageNavNode !== null) {
            pageNavNode.style.top = headerHeightPlusMargin + "px"
          }
          siteNavNode.style.height = siteNavMaxHeight + "px"
        }
      } else {
        // Towards bottom of page
        siteNavNode.style.position = "fixed"
        siteNavNode.style.height = windowInnerHeight - (lastPosition + windowInnerHeight - articleBottom) + "px"
      }
    }
  } else {
    // If article is too small, get back to normal
    siteNavNode.style.position = "sticky"
    siteNavNode.style.top = headerHeightPlusMargin + "px"
    siteNavNode.style.height = null
  }

  scroll(loop)
}

if (siteNavNode !== null) {
  window.onresize = computeSizes

  computeSizes()
  loop()
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

import {MDCToolbar} from '@material/toolbar'

var toolbar = new MDCToolbar(document.querySelector('.mdc-toolbar'))
var subrowNode = document.querySelector('header > .mdc-toolbar__row:first-child .mdc-toolbar__subrow')
var mdcToolbarRowHeight = 64

if (subrowNode !== null) {
  toolbar.listen('MDCToolbar:change', function(evt) {
    var flexibleExpansionRatio = evt.detail.flexibleExpansionRatio
    var computedHeight = mdcToolbarRowHeight * flexibleExpansionRatio
    var remainingHeight = mdcToolbarRowHeight - computedHeight
    subrowNode.style.marginTop = -remainingHeight + "px"
    computeSizes()
  })
}

toolbar.fixedAdjustElement = document.querySelector('.mdc-toolbar-fixed-adjust')
