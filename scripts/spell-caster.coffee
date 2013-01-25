# purpose of this is to cast spells on the fly

Browser = require 'zombie'
url = 'http://localhost:8000'
hostname = 'localhost:8000'
spellName = 'title.js'

browser = new Browser
browser.visit url, (error, browser, statusCode, errors) ->
  spell = require "../spells/#{hostname}/#{spellName}"
  spell browser, (result, found, expected) ->
    console.log "result is #{result}, you sent\n#{found}\nand I expected\n#{expected}"