# Zonda Util Model
# - - -
# Base on Backbone Events.

define ( require, exports, module ) ->
  _ = require "underscore"
  Backbone = require "backbone"

  Genre = require "../genre/genre"
  Http = require "../http/http"

  class Model
    constructor: ( @NAME, @API ) ->
      _.extend @, Backbone.Events

      # Keep the Status of Network
      # - - -
      @connection_stack = []

      # Generate Namespace of this Model
      # - - -
      if @id
        @namespace = "#{@NAME}:#{@id}"
      else
        @namespace = "#{@NAME}"

      # Build Genre for this Model
      # - - -
      @genre = new Genre "@#{@NAME}", @API

      # Generate all Actions of this Model
      # - - -
      _.each @API, ( detail, act ) =>
        if act is "genre"
          return

        @[act] = (request) =>
          @sync act, request

    sync: ( act, request ) ->
      if request isnt undefined and typeof request isnt "object"
        throw "[#{@NAME}] Model.sync ERROR: request is not a object!"

      @genre.inspect  request
      @genre.toRemote request

      @once "#{@namespace}:#{act}:HTTP:success", (respond) =>
        respond = @genre.toLocal respond
        @trigger "#{@namespace}:#{act}:success", respond

      @connection_stack.push Http
        url:       @API[act].url
        data:      request
        caller:    @
        namespace: "#{@namespace}:#{act}"
        fake:      @API[act].fake

    abort: ->
      _.each @connection_stack, (con) ->
        do con.abort

  module.exports = Model

# END define
