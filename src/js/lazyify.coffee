$(document).ready ->

  ###
  # Minimal classList shim for IE 9
  # By Devon Govett
  # MIT LICENSE
  ###

  # if !('classList' of document.documentElement) and Object.defineProperty and typeof HTMLElement != 'undefined'
  #   Object.defineProperty HTMLElement.prototype, 'classList', get: ->
  #     self = this
  #     ret =
  #       add: update((classes, index, value) ->
  #         ~index or classes.push(value)
  #         return
  #       )
  #       remove: update((classes, index) ->
  #         ~index and classes.splice(index, 1)
  #         return
  #       )
  #       toggle: update((classes, index, value) ->
  #         if ~index then classes.splice(index, 1) else classes.push(value)
  #         return
  #       )
  #       contains: (value) ->
  #         ! ! ~self.className.split(/\s+/).indexOf(value)
  #       item: (i) ->
  #         self.className.split(/\s+/)[i] or null

  #     update = (fn) ->
  #       (value) ->
  #         classes = self.className.split(/\s+/)
  #         index = classes.indexOf(value)
  #         fn classes, index, value
  #         self.className = classes.join(' ')
  #         return

  #     Object.defineProperty ret, 'length', get: ->
  #       self.className.split(/\s+/).length
  #     ret
  #
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
