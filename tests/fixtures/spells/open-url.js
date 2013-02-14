module.exports = function (instance, cb) {
  instance.get('http://localhost:8000/tests/fixtures/sample-site.html', function () {
    instance.title(function(err, title) {
      cb(title);
    });
  });
};