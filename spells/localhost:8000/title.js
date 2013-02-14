var expectation = function (found, cb) {
  'use strict';

  var expected = 'Sample site';
  cb(found === expected, found, expected);
};

module.exports = function (instance, cb) {
  'use strict';

  instance.get('http://localhost:8000/tests/fixtures/sample-site.html', function () {
    instance.title(function(err, title) {
      expectation(title, cb);
    });
  });
};