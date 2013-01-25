var expectation = function (found, cb) {
  'use strict';

  var expected = 'Sample site';
  cb(found === expected, found, expected);
};

module.exports = function (instance, cb) {
  'use strict';

  instance.visit('/tests/fixtures/sample-site.html', function () {
    expectation(instance.text('title'), cb);

  });
};