fs           = require 'fs'
path         = require 'path'

autoprefixer = require 'autoprefixer'
comments     = require 'postcss-discard-comments'
csso         = require 'csso'
lost         = require 'lost-stylus'
postcss      = require 'poststylus'
rupture      = require 'rupture'
stylus       = require 'stylus'
pug          = require 'pug'
requisite    = require 'requisite'


debounce = (fn) ->
  waiting = null
  (src, dst) ->
    clearTimeout waiting if waiting?
    waiting = setTimeout fn, 50
    true


writeFile = (dst, content) ->
  fs.writeFile dst, content, 'utf8', (err) ->
    console.error err if err?


compilePug = (src, dst) ->
  filename = path.basename src
  return if filename.charAt(0) == '_'

  opts =
    basedir: __dirname + '/src'
    pretty:  true

    title:     'Stoned Audio'
    copyright: '© Stoned Audio, LLC'

  html = pug.renderFile src, opts
  writeFile dst, html

  true


compileCoffee = ->
  src = 'src/js/app.coffee'
  dst = 'public/js/app.js'

  opts =
    entry:             src
    externalSourceMap: true
    sourceMapURL:      (path.basename dst) + '.map'

  if process.env.PRODUCTION
    opts.minify   = true
    opts.minifier = 'esmangle'

  requisite.bundle opts, (err, bundle) ->
    return console.error err if err?
    {code, map} = bundle.toString opts
    writeFile dst, code
    writeFile dst + '.map', map

  true


compileStylus = ->
  src = 'src/css/app.styl'
  dst = 'public/css/app.css'

  style = require('stylus') fs.readFileSync src, 'utf8'
    .set 'filename', src
    .set 'include css', true
    .set 'paths', [
      __dirname + '/src/css'
      __dirname + '/node_modules'
    ]
    .set 'sourcemap',
      basePath:   ''
      sourceRoot: '../'
    .use lost()
    .use rupture()
    .use postcss [
      autoprefixer browsers: '> 1%'
      'lost'
      'rucksack-css'
      'css-mqpacker'
      comments removeAll: true
    ]

  style.render (err, css) ->
    return console.error err if err

    if process.env.PRODUCTION
      try
        {css} = csso.minify css,
          restructure: true
          debug: true
        writeFile dst, css
      catch err
        console.error err, err.parseError
        lines = css.split '\n'
        lineno = err.parseError.line-1
        for n in [lineno..lineno+2]
          console.error n, lines[n]
        return
    else
      sourceMapURL = (path.basename dst) + '.map'
      css = css + "/*# sourceMappingURL=#{sourceMapURL} */"
      writeFile dst, css
      writeFile dst + '.map', JSON.stringify style.sourcemap

  true


module.exports =
  assetDir: __dirname + '/src'
  buildDir: __dirname + '/public'

  compilers:
    pug:    compilePug
    coffee: debounce compileCoffee
    styl:   debounce compileStylus
