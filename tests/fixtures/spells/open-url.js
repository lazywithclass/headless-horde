module.exports = function (instance, cb) {
  instance.visit('http://localhost:8000/tests/fixtures/sample-site.html', function (e, instance, status) {
    cb(instance.evaluate('document.title'));
  });
};