# these tests require a local server to be running
# look into the Makefile for details on how to start it
describe 'spells', ->

  Browser = require 'zombie'

  it 'could be invoked', (done) ->
    require('./fixtures/spells/simple') (data) ->
      data.should.equal 'done'
      done()

  it 'could get the title', (done) ->
    require('./fixtures/spells/open-url') new Browser, (data) ->
      data.should.equal 'Sample site'
      done()

  it 'could write a custom string in a field', (done) ->
    require('./fixtures/spells/fill-field') new Browser, (data) ->
      data.should.equal 'sample string'
      done()