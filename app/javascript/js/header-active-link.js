import 'mdn-polyfills/Node.prototype.append'

let lastHeaderLink = document.querySelector('header > .mdc-toolbar__row:first-child .flex-row > a:last-child')
if (lastHeaderLink !== null) {
  lastHeaderLink.classList.add('active')
}

let subnavNode = document.querySelector('header > .mdc-toolbar__row + .mdc-toolbar__row')
let mainNode = document.querySelector('main')
if (subnavNode !== null && mainNode !== null) {
  let subnavTarget = document.querySelector('header > .mdc-toolbar__row + .mdc-toolbar__row nav > a')

  if (subnavTarget !== null) {
    let subnavIndexName = mainNode.getAttribute('data-subnav-index')
    if (subnavIndexName !== null) {
      subnavTarget = subnavNode.querySelector(`[data-index='${ subnavIndexName }']`)
    }

    subnavTarget.classList.add("mdc-tab--active")

    let indicatorNode = document.createElement('span')
    indicatorNode.classList.add('mdc-tab__indicator')
    subnavTarget.append(indicatorNode)
  }
}

let docDrawerHeaderLink = document.querySelector('.drawer-nav nav > ul > li.heading:nth-child(4) > a')
if (docDrawerHeaderLink !== null) {
  docDrawerHeaderLink.classList.add('active')
}

let drawerSubnavNode = document.querySelector('.drawer-nav nav > ul > li.heading:nth-child(4) > ul')
if (drawerSubnavNode !== null && mainNode !== null) {
  let subnavTarget = document.querySelector('.drawer-nav nav > ul > li.heading:nth-child(4) > ul > li > a')

  if (subnavTarget !== null) {
    let subnavIndexName = mainNode.getAttribute('data-subnav-index')
    if (subnavIndexName !== null) {
      subnavTarget = drawerSubnavNode.querySelector(`[data-index='${ subnavIndexName }']`)
    }

    subnavTarget.classList.add("active")
  }
}
