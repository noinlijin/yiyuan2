# Test Case for Util Model
define ( require ) ->
  module "Model"

  # Test API
  # - - -
  API =
    genre:
      "id~id : @Number": ""

      "variety~var : @String": ""
      "lifetime~life : @Number": ""

      "min-height~min-h : @Number": ""
      "max-height~max-h : @Number": ""

      "wool~wool : @Array": [
        {
          "type~type : @Array": [
            {
              "name~typename : @String": ""
              "id~typeid : @Number": ""
            }
          ]
          "color~color : @Array": [
            {
              "name~colorname : @String": ""
              "id~colorid : @Number": ""
            }
          ]
        }
      ]

    CREATE:
      url: "/dog/create"
      expire: 1
      fake: true

    UPDATE:
      url: "/dog/update"
      expire: 1
      fake: true

    READ:
      url: "/dog/read"
      expire: 1300
      fake: true

    READ_LIST:
      url: "/dog/read_list"
      expire: 1300
      fake: true

    DELELE:
      url: "/dog/delete"
      expire: 1300
      fake: true

  # - - -
  # Test API

  Util = require "util"

  Model = Util.Model

  dog_Model = new Model "dog", API

  test "API", ->
    ok dog_Model.CREATE
    ok dog_Model.READ
    ok dog_Model.UPDATE
    ok dog_Model.DELELE

    ok dog_Model.genre
    ok dog_Model.NAME
    ok dog_Model.namespace

  asyncTest "act", ->

    dog_Model.once "#{dog_Model.NAME}:READ:success", (respond) ->

      strictEqual respond.variety, "中华田园犬"
      strictEqual respond.id, 1
      do start

    dog_Model.READ id: 1

# END define
