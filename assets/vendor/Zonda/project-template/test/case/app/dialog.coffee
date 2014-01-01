# test case base64
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
    Dialog
      title: "small"
      content: "big"
      button:
        "hehe": ->
    .open()

    ok Dialog.$dom[0]

    strictEqual Dialog.$dom.find(".modal-header h3").text(), "small"

    ok /big/.test Dialog.$dom.find(".modal-body").text()

    ok /hehe/.test Dialog.$dom.find(".modal-footer button[id]").text()

    do Dialog.close
    
  test "Dialog Style", ->
    do Dialog.close

    Dialog
      title: "small"
      content: "big"
      class: "haha"
      button:
        "hehe": ->
    .open()

    ok Dialog.$dom.hasClass "haha"

    do Dialog.close
    
  asyncTest "Dialog button callback", ->
    do Dialog.close

    num = 1

    Dialog
      title: "small"
      content: "big"
      class: "haha"
      button:
        "hehe": ->
          num = 2
    .open()

    Dialog.$dom.find(".modal-footer button.btn-success").trigger "click"

    setTimeout ->
      strictEqual num, 2
      ok Dialog.$dom.find(".modal-footer button.btn-success").hasClass "disabled"
      do start
    , 300

  asyncTest "Dialog button for cancel", ->
    do Dialog.close

    Dialog
      title: "small"
      content: "big"
    .open()

    Dialog.$dom.find(".modal-footer button[aria-hidden=true]").trigger "click"

    setTimeout ->
      id = Dialog.$dom.attr "id"
      ok not $("##{id}")[0]

      do start
    , 300
    
  asyncTest "Dialog Close Delay", ->
    do Dialog.close

    Dialog
      title: "small"
      content: "big"
    .open()

    Dialog.close 400

    setTimeout ->
      id = Dialog.$dom.attr "id"
      ok not $("##{id}")[0]

      do start
    , 400

  asyncTest "Dialog Config", ->
    do Dialog.close

    Dialog
      title: "small"
      content: "big"
    .open()

    Dialog.close 400

    setTimeout ->
      deepEqual Dialog.config,
        title: "small"
        content: "big"

      do start
    , 400

  asyncTest "Chain Style", ->
    do Dialog.close

    Dialog
      title: "small"
      content: "big"
    .open()
    .close 400

    setTimeout ->
      id = Dialog.$dom.attr "id"
      ok not $("##{id}")[0]

      do start
    , 400

# END define
