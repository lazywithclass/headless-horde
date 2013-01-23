request = require 'supertest'
Seq = require 'seq'
app = require '../server'
should = require 'should'

describe 'GET', ->

  afterEach (done) -> request(app).del('/horde').end done

  describe '/info', ->

    it 'provides its version', (done) ->
      request(app).get('/').end (err, res) ->
        JSON.parse(res.text).version.should.equal require('../package').version
        done()

  describe '/horde', ->

    it 'returns an array of instances', (done) ->
      Seq()
        .seq_((next) ->
          request(app)
            .post('/horde')
            .send({ url: 'http://google.com'})
            .end next
        ).seq_((next) ->
          request(app).get('/horde').end (err, res) ->
            data = JSON.parse res.text
            data.should.be.an.instanceOf Array
            should.exist data[0].guid
            should.exist data[0].url
            done()
        )

    it 'returns 404 if client supplies a non existing guid', (done) ->
      request(app).get('/horde/h725').expect(404, done)

    it 'returns a given instance', (done) ->
      guid = ''
      Seq()
        .seq_((next) ->
          request(app)
            .post('/horde')
            .send({ url: 'http://stackoverflow.com'})
            .end (err, res) ->
              guid = JSON.parse(res.text).created.guid
              next()
        ).seq_((next) ->
          request(app).get("/horde/#{guid}").end (err, res) ->
            JSON.parse(res.text).url.should.equal 'http://stackoverflow.com/'
            done()
        )

  describe '/horde/alive', ->

    it 'returns the number of alive members in the horde', (done) ->
      Seq()
        .seq_((next) ->
          request(app)
            .post('/horde')
            .send({ url: 'http://google.com'})
            .end next
        ).seq_((next) ->
          request(app).get('/horde/alive').end (err, res) ->
            JSON.parse(res.text).tot.should.equal 1
            done()
        )

  describe '/spells/:site', ->

    it 'returns the available spells for a site', (done) ->

      request(app)
        .get('/spells/stackoverflow.com')
        .expect(200)
        .end (err, res) ->
          spells = JSON.parse(res.text)
          spells[0].should.have.property 'name', 'questions.js'
          done()