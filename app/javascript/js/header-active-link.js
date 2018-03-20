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
