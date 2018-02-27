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
