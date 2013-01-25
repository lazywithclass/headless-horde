request = require 'supertest'
Seq = require 'seq'
app = require '../server'

describe 'DELETE /horde', ->

  it 'returns 200', (done) ->
    request(app).del('/horde').expect(200, done)

  it 'removes a newly created instance', (done) ->
    Seq()
      .seq_((next) ->
        request(app).del('/horde').end(-> next())
      ).seq_((next) ->
        request(app).post('/horde')
          .send({url: 'http://localhost:8000'})
          .expect('Content-Type', /json/, done)
          .end next
      ).seq_((next) ->
        request(app).get('/horde/alive').end (err, res) ->
          JSON.parse(res.text).tot.should.equal 1
          next()
      ).seq_((next) ->
        request(app).del('/horde').end(-> next())
      ).seq_((next) ->
        request(app).get('/horde/alive').end (err, res) ->
          JSON.parse(res.text).tot.should.equal 0
          done()
      )