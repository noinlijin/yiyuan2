# Zonda Util Dialog
# - - -
# Base on Bootstrap Modal.
# - - -
### Usage:
```coffeescript

  # Define a new Dialog
  Util.Dialog
    title: "I am the title"

    content: "some text/HTML, or Mustache.render output"

    css:
      "height": 1200

    class: "you can add class for this dialog"

    button:
      "Yes": ->
        # Generate the a button named "Yes", and do callback when you click the button

      "Sure[class_name]": ->
        # Use [~class_name] to add class to this button,
        # if class_name is null or you don't use [~...],
        # the button's class_name will be "primary" as default.

      "Other Button": ->
        # callback

  # Open it!
  do Util.Dialog.open

  # Close it!
  do Util.Dialog.close

  # Close dialog delay a moment
  Util.Dialog.close 1200

  # Chain style
  Util.Dialog.open().close(1300)

  # Return the dialog jQuery object
  console.log Util.Dialog.$dom

  # Return the dialog config
  console.log Util.Dialog.config

  # If you want to update the position and height of this dialog, just call:
  do Util.Dialog.open

```
###

define ( require, exports, module ) ->
  $ = require "bootstrap"
  _ = require "underscore"
  Mustache = require "mustache"
  Backbone = require "backbone"

  tpl = require "./tpl/dialog.tpl"

  prefix = "zonda-util"

  # Helper
  # - - -
  buttonNameFilter = (name) ->
    _class_name = name.match /\[~.*\]/

    if _class_name is null
      class_name = "btn-primary"
    else
      class_name = (_class_name[0].replace /\[~/, "").replace /\]/, ""

    return {
      class_name: class_name
      button_name: name.replace /\[~.*\]/, ""
    }

  # Main
  # - - -
  Dialog = (config) ->

    Dialog.config = config

    # Generate DOM of dialog
    # - - -
    if $("##{prefix}-dialog:visible")[0]
      return false

    dialog_html = Mustache.render tpl,
      title: config.title
      content: config.content
      
    $(document.body).append dialog_html
    # - - -
    # Generate DOM of dialog

    # Add Style
    # - - -
    if config.css
      $("##{prefix}-dialog").css config.css

    if config.class
      $("##{prefix}-dialog").addClass config.class
    # - - -
    # Add Style
    
    # Add complete
    # - - -
    if config.complete
      callback = config.complete
      do (callback) ->
        do callback
    # - - -
    # End 

    # Make button
    # - - -
    _.each config.button, ( button_callback, button_name ) ->
      uid = _.uniqueId("#{prefix}-dialog-button-")

      button_info = buttonNameFilter button_name

      $("##{prefix}-dialog .modal-footer").append """
        <a href="javascript:;" id="#{uid}" class="btn #{button_info.class_name}">
          #{button_info.button_name}
        </a>
      """

      $("##{uid}").on "click", ->

        if $(@).hasClass "disabled"
          return false
        else
          $(@).addClass "disabled"

        button_callback.call @

    # - - -
    # Make button

    Dialog.$dom = $("##{prefix}-dialog")

    # Destroy when closing the dialog
    # - - -
    $("##{prefix}-dialog").on "hidden.bs.modal", ->
      delete $("##{prefix}-dialog").modal
      do $("##{prefix}-dialog").remove
      do $(".modal-backdrop").remove
      $("body").removeClass "modal-open"

    return Dialog
  
  # END Dialog

  Dialog.open = ->

    Backbone.Events.trigger "zonda:dialog:open", Dialog

    # Set height of dialog
    # - - -
    $("##{prefix}-dialog .modal-body").css
      "max-height": window.innerHeight-141

    $("##{prefix}-dialog").modal
      show: true
      backdrop: Dialog.config.backdrop

    # - - -
    # Set height of dialog

    return Dialog
  # END dialog.open

  Dialog.close = (delay) ->

    Backbone.Events.trigger "zonda:dialog:close", Dialog

    if delay
      setTimeout ->
        $("##{prefix}-dialog").modal "hide"
      , delay
    else
      $("##{prefix}-dialog").modal "hide"

    return Dialog
  # END dialog.close

  module.exports = Dialog
  
# END define
