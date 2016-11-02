fs   = require 'fs'
path = require 'path'

writeFile = (dst, content) ->
  fs.writeFile dst, content, 'utf8', (err) ->
    console.error err if err?

compilePug = (src, dst) ->
  return if (path.basename src).charAt(0) == '_'

  pug = require 'pug'

  opts =
    basedir:  'src/'
    pretty: true

  html = pug.renderFile src, opts
  writeFile dst, html

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
    writeFile dst, code
    writeFile dst + '.map', map

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
      minified = (new CleanCSS semanticMerging: false).minify css
      writeFile dst, minified.styles
    else
      sourceMapURL = (path.basename dst) + '.map'
      css = css + "/*# sourceMappingURL=#{sourceMapURL} */"
      writeFile dst, css
      writeFile dst + '.map', JSON.stringify style.sourcemap
  true

module.exports =
  workDir:   __dirname + '/src'
  staticDir: __dirname + '/public'

  compilers:
    pug:    compilePug
    coffee: compileCoffee
    styl:   compileStylus
