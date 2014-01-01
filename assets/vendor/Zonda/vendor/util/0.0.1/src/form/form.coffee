# Zonda Util Form
# - - -
# Base on Bootstrap Form.
# Verify, dump, and other method coming soon.
# - - -
# !! Every task of Form is async !!

define ( require, exports, module ) ->
  $ = require "jquery"
  _ = require "underscore"
  Backbone = require "backbone"
  Cell = require "./cell"
  Queue = require "../queue/queue"

  # Main
  # - - -
  # @sel: the jQuery selector of Form DOM
  # @config:
  #   error_only: don't change the style of form when task success
  class Form
    constructor: (@sel, @config) ->
      _.extend @, Backbone.Events

      @cells = Cell sel
      @dom = $ sel
      @name = @dom.attr "name"

      # The name of Form is required
      # - - -
      throw "From:#{@sel} must have a name!" if @name is undefined

    listen: (evt) ->
      _.each @cells, (cell) =>
        if _.keys(cell.tasks).length is 0
          return null
        cell.dom.on evt, =>
          @taskRunner cell

    taskRunner: (cell) ->
      if cell.dom.is ":hidden"
        return null

      if cell.status is "running"
        return null
      else
        cell.status = "running"

      namespace = "#{@name}:#{cell.name}:taskRunner"
      task_number = (_.keys cell.tasks).length
      task_queue = new Queue namespace, task_number

      task_queue.once "#{namespace}:queue:error", (err_cell) ->
        cell.status = "error"
        cell.dom.parents(".form-group")
          .removeClass("has-success")
          .addClass("has-warning")
          .find(".help-block")
          .html """
            <i class="icon-warning-sign"></i> #{err_cell.info}
          """

      task_queue.once "#{namespace}:queue:success", =>
        cell.status = "success"

        form_group = cell.dom.parents(".form-group")

        form_group
          .removeClass("has-warning")
          .find(".help-block")
          .empty()

        return true if @config and @config.error_only

        form_group
          .addClass("has-success")
          .find(".help-block")
          .html """
            <i class="icon-ok-sign"></i>
          """

      # Run Task
      # - - -
      for name of cell.tasks
        throw "No such task named #{name}!" unless name of @tasks
        task_queue.setter name, "running"
        @tasks[name] cell, task_queue

    # END taskRunner

    # Dump the Form Data
    # - - -
    dump: ( callback, context )->
      # Helper
      # - - -
      _callback = (err_cell) =>
        data = {}

        _.each @cells, (cell) ->
          cell.dom.disabled = false

        if callback and not context
          callback err_cell

        if callback and context
          callback.call context, err_cell

      # 1.Disabled All cells of this Form
      # 2.Find out which cells should run task
      # - - -
      task_cells = []

      _.each @cells, (cell) =>
        cell.dom.disabled = true

        if _.keys(cell.tasks).length is 0
          return null

        task_cells.push cell

      # Generate a Queue
      # - - -
      dump_queue = new Queue "#{@name}:dump", task_cells.length

      # Listen to all Events of dump_queue
      # - - -
      dump_queue.once "#{@name}:dump:queue:success", (err_cell) =>
        dump_queue.off "#{@name}:dump:queue:success"
        dump_queue.off "#{@name}:dump:queue:error"
        _callback err_cell

      dump_queue.once "#{@name}:dump:queue:error", (err_cell) =>
        dump_queue.off "#{@name}:dump:queue:success"
        dump_queue.off "#{@name}:dump:queue:error"
        _callback err_cell

      # Run each Cells's Task
      # - - -
      _.each task_cells, (cell) =>
        namespace = "#{@name}:#{cell.name}:taskRunner:queue"
        dump_queue.setter cell.name, "running"

        Backbone.Events.once "#{namespace}:success", ->
          Backbone.Events.off "#{namespace}:success"
          Backbone.Events.off "#{namespace}:error"
          dump_queue.setter cell.name, "success"

        Backbone.Events.once "#{namespace}:error", (err_cell) ->
          Backbone.Events.off "#{namespace}:success"
          Backbone.Events.off "#{namespace}:error"
          dump_queue.setter cell.name, "error", err_cell

        @taskRunner cell

    # END dump

    registerTask: ( name, task, is_global ) ->
      name = do name.toLowerCase
      # throw "Task:#{name} existed!" if name of @tasks
      @tasks[name] = task

    # Build-in task
    # - - -
    tasks:

      # Inspect cell value with the RegExp
      # - - -
      regexp: ( cell, task_queue ) ->

        exp = cell.tasks.regexp.replace /^\//, ""
        exp = exp.replace /\/$/, ""
        exp = new RegExp exp

        if exp.test cell.dom.val()
          task_queue.setter "regexp", "success"
        else
          task_queue.setter "regexp", "error", "格式错误"

  module.exports = Form
  
# END define
