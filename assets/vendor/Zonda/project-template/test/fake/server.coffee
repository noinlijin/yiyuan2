# Zonda Fake HTTP Server
# - - -
# Base on Sinon
define ( require, exports, module ) ->
  require "sinon"
  sinon = window.sinon

  datasource = require "./datasource"

  server = do sinon.sandbox.useFakeServer

  module.exports = (url) ->
    server.respondWith url, (xhr) ->
      request = xhr.requestBody

      request = "" if request is null or request is undefined

      xhr.respond 200,
        "Content-Type": "application/json",
        JSON.stringify
          err: null
          data: datasource[url][request]

    do server.respond

# END define
