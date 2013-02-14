# these tests require a local server to be running
# look into the Makefile for details on how to start it
describe 'spells', ->

  it 'could be invoked', (done) ->
    require('./fixtures/spells/simple') (data) ->
      data.should.equal 'done'
      done()

  it 'could get the title', (done) ->
    require('child_process').exec 'phantomjs --webdriver=9200', (err, stdout, stderr) ->
      instance = require('wd').remote '127.0.0.1', 9200
      instance.init ->
        require('./fixtures/spells/open-url') instance, (data) ->
          data.should.equal 'Sample site'
          done()

  it 'could write a custom string in a field', (done) ->
    require('child_process').exec 'phantomjs --webdriver=9201', (err, stdout, stderr) ->
      instance = require('wd').promiseRemote '127.0.0.1', 9201
      require('./fixtures/spells/fill-field') instance, (data) ->
        data.should.equal 'sample string'
        done()