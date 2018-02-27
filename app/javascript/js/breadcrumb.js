import 'mdn-polyfills/Element.prototype.closest'
import 'mdn-polyfills/Node.prototype.append'

let activeLink = document.querySelector('.site-nav a.active')
let breadcrumbElement = document.querySelector('.breadcrumb')
if (activeLink !== null && breadcrumbElement !== null) {
  let ary = []
  let grandParentLink = activeLink.parentElement.parentElement.previousElementSibling
  while ((grandParentLink !== null) && (grandParentLink.nodeName.toUpperCase() == "A")) {
    ary.push(grandParentLink)
    grandParentLink = grandParentLink.parentElement.parentElement.previousElementSibling
  }

  ary.reverse().forEach((grandParentLink) => {
    let text = grandParentLink.innerHTML.replace(/^\s+|\s+$/g, '')

    let line = document.createElement('li')
    let link = document.createElement('a')
    link.innerHTML = text
    link.setAttribute('href', grandParentLink.getAttribute('href'))
    line.appendChild(link)
    breadcrumbElement.append(line)
  })
}
