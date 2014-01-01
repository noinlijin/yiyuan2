# Zonda Fake HTTP Respond
# - - -
define ( require, exports, module ) ->
  module.exports =
    "/dog/read": require "./data/dog/read"
    "/dog/read_list": require "./data/dog/read_list"
  
# END define
