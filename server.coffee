express = require 'express'
wd = require 'wd'
uuid = require 'node-uuid'
_ = require 'underscore'
info = require './package'
exec = require('child_process').exec

app = express()
# exporting so it could be seen from tests, is there a better alternative?
module.exports = app

app.configure ->
  app.use express.bodyParser()
  app.use app.router

app.all '/*', (req, res, next) ->
  res.header "Access-Control-Allow-Origin", "#{req.headers.origin}"
  res.header "Access-Control-Allow-Credentials", true
  res.header "Access-Control-Allow-Headers", "Content-Type, *"
  res.header 'Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS'
  next()

instances = {}
webdriverPort = 9200

extract = (instance) ->
  guid: instance.guid
  url: instance.url

app.post '/horde', (req, res) ->
  if not req.body.url
    res.json 412,
      'message': 'url missing'
    return
  guid = uuid.v4()
  exec "phantomjs --webdriver=#{webdriverPort}", (err, stdout, stderr) ->
    instance = wd.remote '127.0.0.1', webdriverPort
    instance.init ->
      instance.guid = guid
      instance.url = req.body.url
      instances[guid] = instance
      instance.get req.body.url, ->
        payload =
          'created':
            extract instance
          'horde': (extract i for i in _.toArray instances)
        res.json 201, payload

app.get '/horde', (req, res) ->
  res.json (extract i for i in _.toArray instances)

app.get '/horde/alive', (req, res) ->
  res.json tot: Object.keys(instances).length

app.get '/horde/:guid', (req, res) ->
  instance = instances[req.params.guid]
  if not instance
    res.json 404,
      result: 'error'
      message: "instance #{req.params.guid} doesn't exist"
  else
    res.json 200, url: instance.url

app.delete '/horde', (req, res) ->
  for key in Object.keys(instances)
    instances[key].close()
    delete instances[key]
  res.json 200, null

app.get '/', (req, res) ->
  res.json 200, version: info.version

app.get '/spells/:site', (req, res) ->
  require('fs').readdir "./spells/#{req.params.site}", (err, spells) ->
    res.json 200, (name: s for s in spells)

app.put '/horde/:guid/spells/:spell', (req, res) ->
  guid = req.params.guid
  instance = instances[guid]
  url = instance.window.location.href.replace('http://', '')
  if url.indexOf('/') isnt -1
    url = url.substring(0, url.lastIndexOf('/'))
  spell = require "./spells/#{url}/#{req.params.spell}"
  cb = (res, guid) ->
    (result, found, expected) ->
      res.json 200,
        guid: guid
        result: result
        found: found
        expected: expected
  spell instance, cb(res, guid)

app.listen 3000, -> console.log 'listening on 3000'