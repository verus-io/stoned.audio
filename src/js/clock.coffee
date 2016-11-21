require 'flipclock/compiled/flipclock.min.js'

moment = require 'moment-timezone'

targetDate = moment.tz '2016-11-21 12:00', 'America/Los_Angeles'
nowDate = moment new Date(), moment.tz.guess()

diff = Math.max targetDate.unix() - nowDate.unix(), 0

clock = $('.clock').FlipClock diff,
  clockFace: 'DailyCounter'
  countdown: true

