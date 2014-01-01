# Zonda Util Slide
# - - -
define ( require, exports, module ) ->
  $ = require "jquery-ui"
  _ = require "underscore"
  Backbone = require "backbone"

  Page = require "./page"
  

  # Main Class
  # - - -
  # Slide.config
  #   sel: "ul" of this Slide's selector
  #   autoPlay: true/false
  #   delay: millisecond of autoPlay delay
  #   trans: transition of "goto"
  #
  #   page:
  #     sel: "ul" of page
  #     tpl: Support the Mustache

  class Slide
    constructor: (@config) ->
      _.extend @, Backbone.Events

      @cells = $(config.sel).children()
      @length = do @cells.size

      @now =
        index: 0
        dom: do @cells.first

      @config.trans = "fade" unless @config.trans
      @config.delay = 1000 unless @config.delay
      @config.autoPlay = true unless @config.autoPlay

      @now.dom.fadeIn "fast"

      # Don't Start Slide
      # - - -
      return null if @length <= 1

      # Page of Slide
      # - - -
      Page.call @, config if config.page

      @autoPlay 0

      # MouseEvent Handle
      # - - -
      @cells.on "mouseover", => do @stop
      @cells.on "mouseout", => do @autoPlay

    # Kernel Part
    # - - -
    # where: @Number
    goto: (where) ->
      clearTimeout @timer

      return null if @length <= 1

      # Loop goto
      # - - -
      where = @length + where if where < 0

      where = where - @length if where >= @length

      # Go to where by action of transition
      # - - -
      @trans[@config.trans] where, @now.index, @cells

      old = @now

      @now =
        index: where
        dom: @cells.eq where

      @trigger "#{@config.sel}:goto:slide:success", @now, old

    # Auto Play
    # - - -
    timer: ""

    autoPlay: (init)->
      return null unless @config.autoPlay

      if init is undefined
        where = @now.index+1
      else
        where = init

      @timer = setTimeout =>
        @goto where
        do @autoPlay
      , @config.delay


    next: ->
      @goto @now.index+1
      do @autoPlay

    prev: ->
      @goto @now.index-1
      do @autoPlay

    stop: -> @goto @now.index

    trans:
      is_first_run_slide: true

      fade: ->
        fade = require "./trans-fade"
        fade.apply @, arguments

      move: ->
        move = require "./trans-move"
        move.apply @, arguments

  module.exports = Slide
  
# END define
