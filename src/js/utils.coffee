exports.requestTick = do ->
  ticking = false
  (cb) ->
    return if ticking
    requestAnimationFrame cb
