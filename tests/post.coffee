request = require 'supertest'
Seq = require 'seq'
app = require '../server'
should = require 'should'

describe 'POST /horde', ->

    afterEach (done) -> request(app).del('/horde').end done

    it 'responds with 201 on success', (done) ->
      request(app).post('/horde').send({ url: 'http://localhost:8000'}).expect(201, done)

    it 'responds with 412 without url', (done) ->
      request(app).post('/horde').send({}).expect(412, done)

    it 'responds with json', (done) ->
      request(app).post('/horde').send({ url: 'http://localhost:8000'}).expect('Content-Type', /json/, done)

    it 'creates an instance', (done) ->
      Seq()
      .seq_((next) ->
        request(app).post('/horde')
          .send({ url: 'http://localhost:8000'})
          .expect(201)
          .end next
      ).seq_((next) ->
        request(app).get('/horde/alive').end (err, res) ->
          JSON.parse(res.text).tot.should.equal 1
          done()
      )

    it 'creates an instance returning the new one', (done) ->
      request(app).post('/horde')
        .send({url: 'http://localhost:8000'})
        .expect(201)
        .end (err, res) ->
          data = JSON.parse(res.text)
          should.exist data.created
          should.exist data.created.guid
          should.exist data.created.url
          done()

    it 'creates an instance returning the horde', (done) ->
      request(app).post('/horde')
        .send({url: 'http://localhost:8000'})
        .expect(201)
        .end (err, res) ->
          data = JSON.parse(res.text)
          should.exist data.horde
          data.horde.should.be.an.instanceOf Array
          should.exist data.horde[0].guid
          should.exist data.horde[0].url
          done()