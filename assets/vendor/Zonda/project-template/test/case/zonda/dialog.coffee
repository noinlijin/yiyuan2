# test case dialog
define ( require ) ->
  module "Dialog"

  Util = require "util"

  Dialog = Util.Dialog

  test "API", ->
    ok Dialog.open
    ok Dialog.close
    strictEqual typeof Dialog.open, "function"
    strictEqual typeof Dialog.close, "function"

  test "Dialog Render", ->
    do stop
    Dialog
      title: "small"
      content: "big"
      button:
        "hehe": ->
    .open()

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      ok Dialog.$dom[0]
      strictEqual Dialog.$dom.find(".modal-title").text(), "small"
      ok /big/.test Dialog.$dom.find(".modal-body").text()
      ok /hehe/.test Dialog.$dom.find(".modal-footer button[id]").text()
      do Dialog.close

    $("#zonda-util-dialog").on "hidden.bs.modal", start

  test "Dialog Style", ->
    do stop
    Dialog
      title: "small"
      content: "big"
      class: "haha"
      button:
        "hehe": ->
    .open()

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      ok Dialog.$dom.hasClass "haha"
      do Dialog.close

    $("#zonda-util-dialog").on "hidden.bs.modal", start

    
  test "Dialog button callback", ->
    do stop
    num = 1
    Dialog
      title: "small"
      content: "big"
      class: "haha"
      button:
        "hehe": ->
          num = 2
    .open()

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      Dialog.$dom.find(".modal-footer button.btn-primary").trigger "click"
      strictEqual num, 2
      ok Dialog.$dom.find(".modal-footer button.btn-primary").hasClass "disabled"
      do Dialog.close

    $("#zonda-util-dialog").on "hidden.bs.modal", start

  test "Dialog button for cancel", ->
    do stop
    Dialog
      title: "small"
      content: "big"
    .open()

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      Dialog.$dom.find(".modal-footer button[aria-hidden=true]").trigger "click"

    $("#zonda-util-dialog").on "hidden.bs.modal", ->
      id = Dialog.$dom.attr "id"
      ok not $("##{id}")[0]
      do start
    
  test "Dialog Close Delay", ->
    do stop
    Dialog
      title: "Test the 'Delay Close'"
      content: "This dialog will auto close after 2 seconds."
    .open()

    Dialog.close 2000

    $("#zonda-util-dialog").on "hidden.bs.modal", ->
      id = Dialog.$dom.attr "id"
      ok not $("##{id}")[0]
      do start

  test "Dialog Config", ->
    do stop
    Dialog
      title: "small"
      content: "big"
    .open()

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      deepEqual Dialog.config,
        title: "small"
        content: "big"
      do Dialog.close

    $("#zonda-util-dialog").on "hidden.bs.modal", start

  test "Chain Style", ->
    do stop
    Dialog
      title: "Test Chain Style Method"
      content: "This dialog will auto open, and auto close after 1.3 seconds."
    .open()
    .close 1300

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      ok Dialog.$dom[0]

    $("#zonda-util-dialog").on "hidden.bs.modal", ->
      id = Dialog.$dom.attr "id"
      ok not $("##{id}")[0]
      do start

  test "Add class to button", ->
    do stop
    Dialog
      title: "Add other Class to button"
      content: "Has some colorful buttons~~~"
      button:
        "Danger[~btn-danger]": ->
        "Warning[~btn-warning]": ->
        "Info[~btn-info]": ->
        "Success[~btn-success]": ->
        "Link[~btn-link]": ->
        "Default[~btn-default]": ->
        "hehe[~]": ->
    .open()

    $("#zonda-util-dialog").on "shown.bs.modal", ->
      ok Dialog.$dom.find(".btn-danger")[0]
      ok Dialog.$dom.find(".btn-warning")[0]
      ok Dialog.$dom.find(".btn-info")[0]
      ok Dialog.$dom.find(".btn-success")[0]
      ok Dialog.$dom.find(".btn-link")[0]
      ok Dialog.$dom.find(".btn-default")[0]
      Dialog.close 1300

    $("#zonda-util-dialog").on "hidden.bs.modal", start
