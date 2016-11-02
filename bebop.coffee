fs   = require 'fs'
path = require 'path'

compilePug = (src, dst) ->
  filename = path.basename src
  return if filename.charAt(0) == '_'

  pug = require 'pug'

  opts =
    pretty: true

  html = pug.renderFile src,
    basedir:  'src/'
    pretty:   true

  fs.writeFile dst, html, 'utf8'

compileCoffee = ->
  requisite  = require 'requisite'

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
    fs.writeFile dst, code, 'utf8'
    fs.writeFile dst + '.map', map, 'utf8'

  true

compileStylus = ->
  stylus       = require 'stylus'

  postcss      = require 'poststylus'
  autoprefixer = require 'autoprefixer'
  comments     = require 'postcss-discard-comments'
  lost         = require 'lost-stylus'
  rupture      = require 'rupture'

  CleanCSS     = require 'clean-css'

  src = 'src/css/app.styl'
  dst = 'public/css/app.css'

  style = stylus fs.readFileSync src, 'utf8'
    .set 'filename', src
    .set 'include css', true
    .set 'sourcemap',
      basePath: ''
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
      minified = (new CleanCSS semanticMerging: false).minify css
      fs.writeFile dst, minified.styles, 'utf8'
    else
      sourceMapURL = (path.basename dst) + '.map'
      css = css + "/*# sourceMappingURL=#{sourceMapURL} */"
      fs.writeFile dst, css, 'utf8'
      fs.writeFile dst + '.map', JSON.stringify style.sourcemap, 'utf8'
  true

module.exports =
  workDir: 'public/'

  compilers:
    pug:    compilePug
    coffee: compileCoffee
    styl:   compileStylus
