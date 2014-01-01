# Test Zonda Util Collection
define ( require ) ->
  module "Collection"

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

    READ:
      url: "/dog/read"
      expire: 1300
      fake: true

    READ_LIST:
      url: "/dog/read_list"
      expire: 1300
      fake: true

  Backbone = require "backbone"
  Util = require "util"

  Model = Util.Model
  View = Backbone.View
  Collection = Util.Collection

  collection = new Collection
    NAME: "dog"
    API: API
    Model: Model
    View: View

  test "API", ->
    ok collection.sync,    "'sync' from Model"
    ok collection.fetch,   "Get Model list"
    ok collection.update,  "Updata collection"
    ok collection.factory, "Make Model and View"

  test "Property", ->
    strictEqual typeof collection.model_list, "object"
    strictEqual typeof collection.view_list, "object"

  asyncTest "Fetch", ->
    collection.on "dog:READ_LIST:success", (respond) ->
      ok respond, "Get respond"
      strictEqual collection.model_list["1"].NAME, "dog", "Model Name"
      do start

    do collection.fetch

# END define
