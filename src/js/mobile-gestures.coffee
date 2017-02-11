# Hammer = require 'hammerjs'

# body = document.body

# bodyH = new Hammer body
# bodyH.get('pan').set threshold: 180

# openMenuEl = document.getElementById 'open-menu'
# openCartEl = document.getElementById 'open-cart'

# # listen to events...

# ignore = false
# bodyH.on 'panleft panright', (e)->
#   if ignore
#     return
#   switch e.type
#     when 'panleft'
#       if openMenuEl.checked
#         openMenuEl.checked = false
#         openCartEl.checked = false
#       else if location.pathname.indexOf('checkout') < 0
#         openCartEl.checked = true
#         openMenuEl.checked = false
#       ignore = true
#       setTimeout ->
#         ignore = false
#       , 500
#     when 'panright'
#       if openCartEl.checked
#         openMenuEl.checked = false
#         openCartEl.checked = false
#       else
#         openMenuEl.checked = true
#         openCartEl.checked = false
#       ignore = true
#       setTimeout ->
#         ignore = false
#       , 500
