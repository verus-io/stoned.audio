url = 'https://stoned.audio'

description = """
  Huge sound, noise isolation, in-ear mic, on the go charging, single button control and secure, customizable fit. Zero wires.
  """

email =
  subject: "You need to get Stoned"
  body: """
    Stoned Earphones – Huge sound, noise isolation, in-ear mic, on the go
    charging, single button control and secure, customizable fit. Zero wires.

    I'm getting Stoned. Are you?"""

twitter =
  username: 'StonedHQ'
  hashtags: 'stoned,getstoned,stonedlife'
  text:     "I'm getting Stoned. Are you?"

pinterest =
  text: 'Stoned Earphones – Huge sound, noise isolation, in-ear mic, on the go charging, single button control and secure, customizable fit. Zero wires.'

module.exports =
    site:
      title:     'Stoned Audio'
      name:      'stoned.audio'
      url:       url
      copyright: '© Stoned Audio 2016'

    shipDate: 'February 17'
    shipping:
      prelaunch2016december:
        date: 'January'
      2:
        date: 'Febuary'

    meta:
      description: description

      facebook:
        appid:       '1648878842071733'
        description: description
        image:       'https://stoned.audio/img/fbshare.jpg'
        title:       'Get Stoned'

      twitter:
        description: description
        image:       'https://stoned.audio/img/twittershare.jpg'
        title:       'Get Stoned'

    social:
      email:
        shareLink: "mailto:?subject=#{encodeURIComponent email.subject}&body=#{encodeURIComponent email.body}"
      twitter:
        username:  "@#{twitter.username}"
        shareLink: "https://twitter.com/intent/tweet?url=#{encodeURIComponent url}&text=#{encodeURIComponent twitter.text}&hashtags=#{twitter.hashtags}&via=#{twitter.username}&original_referer=#{encodeURIComponent url}"
      facebook:
        username:  'StonedHQ'
        shareLink: 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent url
      googlePlus:
        shareLink: 'https://plus.google.com/share?url=' + encodeURIComponent url
      pinterest:
        shareLink: 'http://pinterest.com/pin/create/button/?url=' + encodeURIComponent(url) + '&media=' + encodeURIComponent(url + '/img/fbshare.jpg') + '&description=' + encodeURIComponent pinterest.text

    legal:
      email:   'legal@stoned.audio'
      name:    'Stoned Audio, LLC'
      address: '405 Southwest Blvd #200, Kansas City, MO 64108'
      state:   'Missouri'

    contact:
      email: 'hi@stoned.audio'
      phone: '(816) 542-0559'

    press:
      name:  'Zach Kelling'
      email: 'press@stoned.audio'
      phone: '(816) 542-0559'

    support:
      email: 'support@stoned.audio'
