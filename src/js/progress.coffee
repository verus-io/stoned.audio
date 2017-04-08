import {requestTick} from './utils'

$(document).ready ->
  $progress = $('.progress')
  if !$progress[0]
    return

  $style = $('<style></style>')
  $progress.append $style

  progressFn = ->
    offset = $progress.offset()
    if offset.top > $(window).height() + $(window).scrollTop()
      return

    value = $progress.attr('data-value')
    units = $progress.attr('data-units')

    if value == ''
      value = 0

    valueNumber = parseFloat value
    valueString = '' + value
    if valueNumber < 10
      value = 10

    $style.html("""
      .progress .bar:before {
        content: '#{valueString}#{units}';
        width: #{value};
      }

      .progress .bar:after {
        left: #{value};
      }""")

    $(window).off 'scroll touchmove mousewheel', fn

  fn = ->
    requestTick progressFn
  $(window).on 'scroll touchmove mousewheel', fn

  $progress.each ->
    this.progress = fn

  # $.ajax(
  #   url: 'https://api.hanzo.io/campaign/earphones/progress?token=' + 'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJiaXQiOjQ1MDM2MTcwNzU2NzUxNzIsImp0aSI6ImZBcnVLbXhLUXE0Iiwic3ViIjoiNE5UeFhsUXJ0YiJ9.fOUs-H-ALpW2LtZfwT7D1sAn3Ipq7NYvnTclRZGXwRK7XvIBBovQgjB8xmezllH65LYR6hl_Wz8tr6wREJV_OQ'
  # ).done (data)->
  #   nowvalue = parseInt(data.progress * 10, 10) / 10
  #   $progress.attr 'data-value', nowvalue
  #   fn()

  fn()

  # deltavalue = parseFloat(value) / 100

  # i = 0

  # counterFn = ->
  #   if i <= 100
  #     sumvalue = (parseInt (deltavalue * i) * 10, 10) / 10
  #     i++

  #     $style.html("""
  #       <style>
  #         .progress .bar:before {
  #           content: '#{sumvalue}% RESERVED';
  #           width: #{value};
  #         }

  #         .progress .bar:after {
  #           left: #{value};
  #         }
  #       </style>""")
  #     requestAnimationFrame counterFn

  # requestAnimationFrame counterFn

