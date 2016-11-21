$(document).ready ->
  instance = Layzr
    normal: 'data-lazy'
    threshold: 250

  instance.on 'src:after', (element) ->
    if element.tagName == 'IMG'
      return
    element.style.backgroundImage = 'url(' + element.getAttribute('src') + ')'
    element.className = (element.className + ' lazy-loaded').trim()
    requestAnimationFrame ->
      element.removeAttribute 'data-lazy'

  instance.update().check().handlers true
