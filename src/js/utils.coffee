raf = require 'raf'

exports.requestAnimationFrame = raf

exports.requestTick = do ->
  ticking = false
  (cb) ->
    return if ticking
    raf cb
