# purpose of this is to cast spells on the fly

wd = require 'wd'
exec = require('child_process').exec
argv = require('optimist')
  .usage('Usage: $0 -n name')
  .demand('n')
  .argv

url = 'http://localhost:8000'
hostname = 'localhost:8000'
spellName = argv.n

exec 'phantomjs --webdriver=9200', (err, stdout, stderr) ->
  instance = wd.promiseRemote '127.0.0.1', 9200
  instance.init ->
    spell = require "../spells/#{hostname}/#{spellName}"
    spell instance, (success, found, expected) ->
      if success
        console.log '✔'
      else
        console.log "✖ expected '#{expected}' but found '#{found}'"