# Zonda Util StateMachine
# - - -
# Base on Backbone Events.
# - - -
# state machine for View
# control the UI
# - - -
### Usage:
 too much to say...
 write this later maybe...
###

define ( require, exports, module ) ->
  _ = require "underscore"
  Backbone = require "backbone"

  StateMachine = ->

  _.extend StateMachine::, Backbone.Events

  StateMachine::add = (view) ->
    @on "view:change", (curr) ->
      if curr is view
        view.activate()
      else
        view.deactivate()
    , @

    view.active = =>
      @.trigger "view:change", view

  module.exports = StateMachine

# END define
