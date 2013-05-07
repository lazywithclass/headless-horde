# headless-horde

## Update

When I wrote this I did not know about [PhantomJS](http://phantomjs.org/release-1.8.html) webdriver support.
So this should be updated to use the features offered by that PhantomJS release.

## Description

Bend an horde of headless browsers to your will.
The browsers are managed through REST calls.

To run the app

 * make run

To run the tests

 * make test
 * make massive - to test how many instances you could handle

There isn't documentation, if you want to know more have a look at the tests.


## Ideas and nice to have stuff

 * make all tests run on the localhost http server, with the page specified in the fixtures

 * what about using https://github.com/caolan/async instead of Seq? It seems to have a clener API

 * what about replacing underscore with lodash? Why?

 * should be able to be notified about what each browser
    is doing
    what page is it on
    last few events it got
    some events that might have been fired
