run:
	node server.js

start-test-server:
	./scripts/start-server.sh &
stop-test-server:
	./scripts/stop-server.sh

test:
	./node_modules/.bin/mocha -r should -t 20000 --reporter spec tests/
test-spells:
	./node_modules/.bin/mocha -r should -t 20000 --reporter spec tests/spells.js
test-get:
	./node_modules/.bin/mocha -r should -t 20000 --reporter spec tests/get.js
test-put:
	./node_modules/.bin/mocha -r should -t 20000 --reporter spec tests/put.js
test-delete:
	./node_modules/.bin/mocha -r should -t 20000 --reporter spec tests/delete.js
test-post:
	./node_modules/.bin/mocha -r should -t 20000 --reporter spec tests/post.js

massive:
	./node_modules/.bin/mocha -r should -t 20000 tests/massive