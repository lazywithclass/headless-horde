// Generated by CoffeeScript 1.3.3
(function() {
  var Seq, app, request;

  request = require('supertest');

  Seq = require('seq');

  app = require('../server');

  describe('DELETE /horde', function() {
    it('returns 200', function(done) {
      return request(app).del('/horde').expect(200, done);
    });
    return it('removes a newly created instance', function(done) {
      return Seq().seq_(function(next) {
        return request(app).del('/horde').end(function() {
          return next();
        });
      }).seq_(function(next) {
        return request(app).post('/horde').send({
          url: 'http://google.com'
        }).expect('Content-Type', /json/, done).end(next);
      }).seq_(function(next) {
        return request(app).get('/horde/alive').end(function(err, res) {
          JSON.parse(res.text).tot.should.equal(1);
          return next();
        });
      }).seq_(function(next) {
        return request(app).del('/horde').end(function() {
          return next();
        });
      }).seq_(function(next) {
        return request(app).get('/horde/alive').end(function(err, res) {
          JSON.parse(res.text).tot.should.equal(0);
          return done();
        });
      });
    });
  });

}).call(this);
