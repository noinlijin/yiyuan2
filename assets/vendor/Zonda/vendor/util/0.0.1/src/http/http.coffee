# Zonda Util Http
# - - -
# Encapsulate the $.ajax

define ( require, exports, module ) ->
  $ = require "jquery"

  #FakeServer = require "test/fake/server"
  Exception = require "../exception/exception"

  Http = (config) ->

    $.ajaxSetup
      dataType : "JSON"
      type : "POST"

      error : (error) ->
        return null unless config.caller

        config.caller.trigger "#{config.namespace}:HTTP:error",
          error,
          config.data

        Exception "network",
          caller: config.caller
          url: config.url
          status: error.status
          statusText: error.statusText
          responseText: error.responseText

      success: (respond) ->
        return null unless config.caller

        if (respond.status and respond.status isnt 1) or (respond.err and respond.err isnt null)
          config.caller.trigger "#{config.namespace}:HTTP:error",
            respond.info,
            config.data

        else
          config.caller.trigger "#{config.namespace}:HTTP:success",
            respond.data,
            config.data

    # END $.ajaxSetup
    #FakeServer config.url

    $.ajax config

  module.exports = Http
  
# END define
