url = 'https://stoned.audio'

description = """
  Stoned Earphones – Audiophile quality sound, on the go charging,
  single button control, active noise cancellation and in-ear mic.
  Experience true wireless earphones designed without compromise.
  """

email =
  subject: 'I want you to get Stoned!'
  body: """
    Audiophile quality sound, on the go charging, single button control, active
    noise cancellation and in-ear mic... Who wouldn't want to get Stoned
    Earphones? Grab your pair at #{url}.
    """

twitter =
  username: 'StonedHQ'
  hashtags: 'GetStoned,StonedAudio'
  text:     "I'm getting Stoned. True wireless earphones with audiophile quality sound."

module.exports =
    site:
      title:     'Stoned Audio'
      name:      'stoned.audio'
      url:       url
      copyright: '© Stoned Audio 2016'

    meta:
      description: description

      facebook:
        description: description
        image:       'https://stoned.audio/img/twittershare.jpg'
        title:       'Get Stoned.'

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

    legal:
      email:   'legal@stoned.audio'
      name:    'Stoned Audio, LLC'
      address: '244 Madison Avenue, 10016-2417 New York City, New York'
      state:   'Missouri'

    contact:
      email: 'hi@stoned.audio'
      phone: '(650) 318-1319'

    press:
      name:    'Zach Kelling'
      email:   'press@stoned.audio'
      phone:   '(650) 318-1319'

    support:
      email: 'support@stoned.audio'

