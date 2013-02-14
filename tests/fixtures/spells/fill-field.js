module.exports = function (instance, cb) {
  instance.init()
  .then(function () {
    return instance.get('http://localhost:8000/tests/fixtures/sample-site.html');
  }).then(function () {
    return instance.eval("document.querySelector('#sample-input').value = 'sample string';");
  }).then(function () {
    return instance.eval("document.querySelector('#sample-input').value;");
  }).then(function (value) {
    cb(value);
  });
};