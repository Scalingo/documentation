import 'mdn-polyfills/Node.prototype.append'
import {MDCTabBar} from '@material/tab-bar'

let lastHeaderLink = document.querySelector('header > .mdc-top-app-bar__row:first-child .flex-row > a:last-child')
if (lastHeaderLink !== null) {
  lastHeaderLink.classList.add('active')
}

let subnavNode = document.querySelector('.scalingo-toolbar--custom + .scalingo-toolbar--custom')
let mainNode = document.querySelector('main')
if (subnavNode !== null && mainNode !== null) {
  const tabBarNode = subnavNode.querySelector('.mdc-tab-bar')
  const tabBar = new MDCTabBar(tabBarNode)

  let subnavIndexName = mainNode.getAttribute('data-subnav-index')
  tabBar.activateTab(subnavIndexName)
}

let docDrawerHeaderLink = document.querySelector('.mdc-drawer > .mdc-drawer__content > .mdc-list > .mdc-list-item:nth-child(6)')
if (docDrawerHeaderLink !== null) {
  docDrawerHeaderLink.classList.add('active')
}

let drawerSubnavNode = document.querySelector('.mdc-drawer > .mdc-drawer__content > .mdc-list > .mdc-list')
if (drawerSubnavNode !== null && mainNode !== null) {
  let subnavIndexName = mainNode.getAttribute('data-subnav-index')
  if (subnavIndexName !== null) {
    let subnavTarget = drawerSubnavNode.querySelector(`[data-index='${ subnavIndexName }']`)
    subnavTarget.classList.add("active")
  }

}

var foldableAppBar = document.querySelector('.scalingo-toolbar--custom + .scalingo-toolbar--custom');
var calculatedPeekHeight = foldableAppBar.clientHeight - document.querySelector('.scalingo-toolbar--custom + .scalingo-toolbar--custom .mdc-top-app-bar__row:last-of-type').clientHeight;
window.addEventListener('scroll', function(e) {
  var peekHeight = Math.min(window.scrollY, calculatedPeekHeight);
  foldableAppBar.style.transform = 'translateY(' + peekHeight * -1 + 'px)';
})
