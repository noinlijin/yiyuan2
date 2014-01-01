## select
define (require,exports, module) ->
  Mustache = require "mustache"
  $ = require "jquery"

  tpl = require "./tpl/select.tpl"
  data = require "./data/select.json"

  html = Mustache.render(tpl,data)

  $("#select-contain").append html

  getCurrentItem = ->
    for i in [0...$(".questioin-item").length]
      console.log $(".questioin-item").eq(i)

      if $(".questioin-item").eq(i).hasClass("show")
        return $(".questioin-item").eq(i)


  hideAll = ->
    for i in [0...$(".questioin-item").length]
      $(".questioin-item").eq(i).removeClass "show"
      $(".questioin-item").eq(i).addClass "hide"

  show = (number) ->
    do hideAll

    $(".questioin-item").eq(number).removeClass "hide"
    $(".questioin-item").eq(number).addClass "show"

  show(0)

  next = ->
    if  getCurrentItem().attr("value") == $("#select-contain :last-child").attr("value")
      return
    do hideAll
    console.log getCurrentItem()
    getCurrentItem().next().removeClass "hide"
    getCurrentItem().next().addClass "show"

  prev = ->
    if  getCurrentItem().attr("value") == $("#select-contain :first-child").attr("value")
      return
    do hideAll
    getCurrentItem().prev().removeClass "hide"
    getCurrentItem().prev().addClass "show"


  $('.prev-button').on "click", ->
    do prev

  $(".next-button").on "click", ->
    do next

# end define
