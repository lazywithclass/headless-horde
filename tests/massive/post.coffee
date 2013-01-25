request = require 'supertest'
Seq = require 'seq'
app = require '../../server'
_ = require 'underscore'

describe 'POST', ->

  describe '/spooky', ->

    # for some reason this is the max number of clients,
    # will have to investigate, it'strange because a run with 337
    # completes in ~720ms while one with 338 seems to hang
    n = 337

    it 'creates n instances', (done) ->
      create ->
        request(app).get('/horde/alive').end (err, res) ->
          JSON.parse(res.text).tot.should.equal n
          done()

    create = (done) ->
      Seq()
        .seq_((next) ->
          request(app).del('/horde').end -> next()
        ).seq_((next) ->
          request(app).get('/horde/alive').end (err, res) ->
            JSON.parse(res.text).tot.should.equal 0
            next()
        ).seq_((next) ->
          _.times n, (i) ->
            request(app)
              .post('/horde')
              .send({url: 'http://localhost:8000'})
              .expect(201)
              .end ->
                console.log "created #{i}th instance"
                if i is n - 1 then done()
        )