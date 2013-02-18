var expectation = function (found, cb) {
  'use strict';

  var expected = 'Sample site';
  cb(found === expected, found, expected);
};

module.exports = function (instance, cb) {
  'use strict';

  instance.get('http://localhost:8000/tests/fixtures/sample-site.html')
    .then(function () {
      return instance.title();
    })
    .then(function (title) {
      expectation(title, cb);
    });
};