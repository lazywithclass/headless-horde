#!/bin/bash

./node_modules/.bin/http-server --silent -p 8000 &
echo $! > ./server.pid