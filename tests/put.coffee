request = require 'supertest'
Seq = require 'seq'
app = require '../server'

describe 'PUT', ->

  afterEach (done) -> request(app).del('/horde').end done

  describe '/horde/spells/:spell', ->

    it 'casts a spell on the horde', (done) ->
      spell = ''
      guid = ''
      Seq()
        .seq_((next) ->
          request(app).post('/horde')
            .send({ url: 'http://localhost:8000'})
            .end (err, res) ->
              guid = JSON.parse(res.text).created.guid
              next()
        ).seq_((next) ->
          request(app)
            .get('/spells/localhost:8000')
            .end (err, res) ->
              spell = JSON.parse(res.text)[0].name
              next()
        ).seq_((next) ->
          request(app).put("/horde/#{guid}/spells/#{spell}").end (err, res) ->
            JSON.parse(res.text).result.should.equal true
            done()
        )