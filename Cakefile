use 'sake-outdated',
  ignore: 'jquery'
use 'sake-publish',
  deploy:
    remote:  'origin'
    refspec: 'master:master'
  npm: false
use 'sake-version'

task 'build:pre', '', ->
  exec '''
       mkdir -p public/css
       mkdir -p public/js
       '''

task 'build', 'build project', ['build:pre'], ->
  exec 'bebop compile'

task 'watch', 'watch for changes and recompile project', ['build:pre'], ->
  exec 'bebop'
