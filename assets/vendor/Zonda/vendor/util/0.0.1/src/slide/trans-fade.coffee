# Transition of Slide
# - - -
define ( require, exports, module ) ->

  module.exports = ( where, now, cells ) ->
    cells.eq(where).stop().fadeIn 1000
    return null if where is now
    cells.eq(now).stop().fadeOut 1000
  
# END define
