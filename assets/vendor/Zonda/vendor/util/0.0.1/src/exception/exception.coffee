# Zonda Util Exception
# - - -
define ( require, exports, module ) ->
  Exception = ( type, error ) ->

    switch type

      when "network"
        throw """ HTTP ERROR!
          caller: #{error.caller.NAME}
          url: #{error.url}
          status: #{error.status}
          responseText: \n#{error.responseText}
        """

      when "genre"
        throw """ Genre ERROR!
          position: #{error.position}
          expect: #{error.expect}
          not: #{error.not}
        """

  module.exports = Exception
  
# END define
