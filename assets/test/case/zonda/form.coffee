# test case form
define ( require ) ->
  Backbone = require "backbone"
  Util = require "util"
  Mustache = require "mustache"

  form_html_mini = """
    <form name="test-form" class="form-horizontal">
      <fieldset>
       <legend>Mini Form</legend>

        <div class="form-group">
          <label for="test-text" class="col-lg-2 control-label">text</label>
          <div class="col-lg-5">
            <input id="test-text" class="form-control" type="text" name="test-text" task-RegExp="/[^^\\s{0,}$]/" placeholder="something..." />
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>
      </fieldset>
    </form>
  """

  form_html_mid = """
    <form name="test-form" class="form-horizontal">
      <fieldset>
       <legend>Mini Form</legend>

        <div class="form-group">
          <label for="test-text" class="col-lg-2 control-label">text</label>
          <div class="col-lg-5">
            <input id="test-text" class="form-control" type="text" name="test-text" task-RegExp="/[^^\\s{0,}$]/" task-foo="hehe" placeholder="something..." />
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>
      </fieldset>
    </form>
  """

  form_html = """
    <form name="test-form" class="form-horizontal">
      <fieldset> <legend>All kind of form cell</legend> 
        <div class="form-group">
          <label for="test-text" class="col-lg-2 control-label">text</label>
          <div class="col-lg-5">
            <input id="test-text" class="form-control" type="text" name="test-text" task-RegExp="/[^^\\s{0,}$]/" />
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

        <div class="form-group">
          <label class="col-lg-2 control-label" for="test-password">password</label>
          <div class="col-lg-5">
            <input id="test-password" class="form-control" type="password" name="test-password" task-RegExp="/[^^\\s{0,}$]/" />
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

        <div class="form-group">
          <label class="col-lg-2 control-label" for="test-password-retype">pd:retype</label>
          <div class="col-lg-5">
            <input id="test-password-retype" class="form-control" type="password" name="test-password-retype" task-RegExp="/[^^\\s{0,}$]/" />
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

        <div class="form-group">
          <div class="col-lg-offset-2 col-lg-5">
            <div class="checkbox">
              <label>
                <input id="test-checkbox" name="test-checkbox" type="checkbox"> checkbox
              </label>
            </div>
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

        <div class="form-group">
          <label class="col-lg-2 control-label" for="test-textarea">textarea</label>
          <div class="col-lg-5">
            <textarea id="test-textarea" class="form-control" name="test-textarea" rows="3" task-RegExp="/[^^\\s{0,}$]/"></textarea>
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

        <div class="form-group">
          <div class="col-lg-offset-2 col-lg-5">
            <div class="radio">
              <label for="test-radio-a">
                <input id="test-radio-a" type="radio" name="test-radio" />
                radio a
              </label>
            </div>
            <div class="radio">
              <label for="test-radio-b">
                <input id="test-radio-b" type="radio" name="test-radio" />
                radio b
              </label>
              </label>
            </div>
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

        <div class="form-group">
          <label class="col-lg-2 control-label" for="test-select">select</label>
          <div class="col-lg-5">
            <select default="2" id="test-select" class="form-control" name="test-select" task-RegExp="/[^^\\s{0,}$]/">
              <option value="0">0</option>
              <option value="1">1</option>
              <option value="2">2</option>
            </select>
          </div>
          <span class="col-lg-5 help-block"></span>
        </div>

      </fieldset>
    </form>
  """

  module "Form"

  test "API", ->
    ok Util.Form
    ok Util.Form::taskRunner
    strictEqual typeof Util.Form::taskRunner, "function"
    ok Util.Form::dump
    strictEqual typeof Util.Form::dump, "function"
    ok Util.Form::listen
    strictEqual typeof Util.Form::listen, "function"
    ok Util.Form::registerTask
    strictEqual typeof Util.Form::registerTask, "function"

  test "cells / initialize / constructe", ->
    Util.Dialog
      title: "Form Test"
      content: form_html
      backdrop: false
    .open()

    do stop

    Util.Dialog.$dom.on "shown.bs.modal", ->
      form = new Util.Form "form[name=test-form]"
      ok form.cells
      ok form.sel
      ok form.dom

      strictEqual (Object::toString.call form.cells), "[object Array]"
      strictEqual form.cells.length, 8

      for cell in form.cells
        if cell.type is "text"
          ok cell.tasks.regexp
          strictEqual cell.tasks.regexp, "/[^^\\s{0,}$]/"

      do Util.Dialog.close

    Util.Dialog.$dom.on "hidden.bs.modal", start

  test "taskRunner", ->
    # success and error
    expect 2

    Util.Dialog
      title: "Form Test"
      content: form_html_mini
      backdrop: false
    .open()

    do stop

    Util.Dialog.$dom.on "shown.bs.modal", ->
      form = new Util.Form "form[name=test-form]"

      for cell in form.cells
        if cell.name is "test-text"
          test_cell = cell # Test Form Cell

      namespace = "#{form.name}:test-text:taskRunner"

      Backbone.Events.once "#{namespace}:queue:error", ->
        setTimeout ->
          ok ($(form.sel).find("input:text").parents(".form-group").hasClass "has-warning")
        , 500

      Backbone.Events.once "#{namespace}:queue:success", ->
        setTimeout ->
          ok ($(form.sel).find("input:text").parents(".form-group").hasClass "has-success")
          do Util.Dialog.close
        , 500

      # Simulate Error
      # - - -
      setTimeout ->
        test_cell.dom.val "    "
        form.taskRunner test_cell
      , 300

      # Simulate Success
      # - - -
      setTimeout ->
        test_cell.dom.val "not null"
        form.taskRunner test_cell
      , 1600

    Util.Dialog.$dom.on "hidden.bs.modal", start

  test "dump taskRunner", ->
    # success and error
    expect 2

    Util.Dialog
      title: "Form Test"
      content: form_html
      backdrop: false
    .open()

    do stop

    Util.Dialog.$dom.on "shown.bs.modal", ->
      form = new Util.Form "form[name=test-form]"

      namespace = "#{form.name}:dump:queue"

      Backbone.Events.once "#{namespace}:error", ->
        ok 1

      Backbone.Events.once "#{namespace}:success", ->
        ok 1
        setTimeout ->
          do Util.Dialog.close
        , 1300

      # Simulate Error
      # - - -
      setTimeout ->
        do form.dump
      , 500

      # Simulate Success
      # - - -
      setTimeout ->
        $("#test-text").val("hehe")
        $("#test-password").val("hehe")
        $("#test-password-retype").val("hehe")
        $("#test-textarea").val("hehe")
        do form.dump
      , 1500

    Util.Dialog.$dom.on "hidden.bs.modal", start

  test "dump error callback", ->
    Util.Dialog
      title: "Form Test"
      content: form_html
      backdrop: false
    .open()

    do stop

    Util.Dialog.$dom.on "shown.bs.modal", ->
      form = new Util.Form "form[name=test-form]"

      # Simulate Error
      # - - -
      setTimeout ->
        form.dump (err_cell) ->
          ok err_cell
          strictEqual err_cell.status, "error"
          do Util.Dialog.close
      , 500

    Util.Dialog.$dom.on "hidden.bs.modal", start

  test "listen and taskRunner", ->
    Util.Dialog
      title: "Form Test"
      content: form_html
      backdrop: false
    .open()

    do stop

    Util.Dialog.$dom.on "shown.bs.modal", ->
      form = new Util.Form "form[name=test-form]"
      form.listen "change"

      $("#test-text").val("    ").trigger("change")

      setTimeout ->
        ok $("#test-text").parents(".form-group").hasClass "has-warning"
        $("#test-text").val("hehehe").trigger("change")
      , 300

      setTimeout ->
        ok $("#test-text").parents(".form-group").hasClass "has-success"
        do Util.Dialog.close
      , 1000

    Util.Dialog.$dom.on "hidden.bs.modal", start

  test "registerTask", ->
    Util.Dialog
      title: "Form Test"
      content: form_html_mid
      backdrop: false
    .open()

    do stop

    foo = ( cell, task_queue ) ->
      value = do cell.dom.val

      if value is "hehe"
        task_queue.setter "foo", "success"
      else
        task_queue.setter "foo", "error", "Where is 'hehe'?"

    Util.Dialog.$dom.on "shown.bs.modal", ->
      form = new Util.Form "form[name=test-form]"

      form.registerTask "foo", foo
      form.listen "change"

      # Simulate
      # - - -
      $("#test-text").val("xixi").trigger("change")

      setTimeout ->
        ok $("#test-text").parents(".form-group").hasClass "has-warning"
        $("#test-text").val("hehe").trigger("change")
      , 1000

      setTimeout ->
        ok $("#test-text").parents(".form-group").hasClass "has-success"
        do Util.Dialog.close
      , 2500

    Util.Dialog.$dom.on "hidden.bs.modal", start
