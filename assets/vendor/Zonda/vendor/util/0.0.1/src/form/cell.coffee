# Zonda Util Form Cell
# - - -
# Generate Form Cell Object
# Base on Bootstrap

define ( require, exports, module ) ->

  # Helper
  # - - -
  # task attributes filter
  filter = ( attrs ) ->
    tasks = {}

    for key, attr of attrs
      continue unless typeof attr is "object"
      continue if attr is null

      name = attr.name.toLowerCase()

      continue unless /^task-/.test name
      name = name.replace /^task-/, ""
      tasks[name] = attr.value

    return tasks

  ALIAS =
    "INPUT:text":     "text"
    "INPUT:password": "password"
    "INPUT:radio":    "radio"
    "INPUT:checkbox": "checkbox"
    "TEXTAREA":       "textarea"
    "SELECT":         "select"

  # Factory
  # - - -
  # @form: the jQuery selector of Form DOM
  Wrap = (form) ->
    cells = []

    for sel, type of ALIAS
      $(form).find(sel).each ->
        cells.push new Cell type, @

    return cells

  # Main
  # - - -
  # Make a Form cell to Cell Object
  class Cell
    constructor: ( @type, cell ) ->
      attrs = cell.attributes

      cell = $ cell
      @dom = cell
      @group_dom = @dom.parents ".form-group"
      
      @name = cell.attr "name"
      @default = cell.attr "default"
      value = cell.attr "value"

      if @default isnt undefined and value is undefined
        cell.val @default

      # Generate the task list of this cell
      # - - -
      @tasks = filter attrs

  module.exports = Wrap
  
# END define
