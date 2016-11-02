require 'shortcake'

use 'cake-test'
use 'cake-version'
use 'cake-publish',
  deploy:
    remote:  'origin'
    refspec: 'master:master'
  npm: false

task 'mkdir', '', ->
  exec '''
       mkdir -p public/css
       mkdir -p public/js
       '''

task 'build', 'build project', ['mkdir'], ->
  exec 'bebop compile --work-dir .'

task 'watch', 'watch for changes and recompile project', ['mkdir'], ->
  exec 'bebop'
