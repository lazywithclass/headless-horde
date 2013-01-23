var expectation = function (found, cb) {
  'use strict';

  var expected = 'Newest Questions - Stack Overflow';
  cb(found === expected, found, expected);
};

module.exports = function (instance, cb) {

  'use strict';

  instance.clickLink('#nav-questions', function () {
    expectation(instance.text('title'), cb);
  });
};