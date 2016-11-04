require 'shortcake'

use 'cake-test'
use 'cake-version'
use 'cake-publish',
  deploy: false
  npm: false

task 'build:pre', '', ->
  exec '''
       mkdir -p public/css
       mkdir -p public/js
       '''

task 'build', 'build project', ['build:pre'], ->
  exec 'bebop compile'

task 'watch', 'watch for changes and recompile project', ['build:pre'], ->
  exec 'bebop'
