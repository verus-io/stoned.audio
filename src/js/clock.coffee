require 'flipclock/compiled/flipclock.min.js'

targetDate = new Date '11/21/2016'
nowDate = new Date()

diff = Math.max (targetDate.getTime() - nowDate.getTime()) / 1000, 0

clock = $('.clock').FlipClock diff,
  clockFace: 'DailyCounter'
  countdown: true

