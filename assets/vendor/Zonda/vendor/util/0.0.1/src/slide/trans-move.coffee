# Transition of Slide
# - - -
define ( require, exports, module ) ->

  module.exports = ( where, now, cells ) ->

    dis = cells.first().parent().outerWidth()

    ###
    # It seem do not need this
    if @is_first_run_slide
      cells.eq(now).fadeIn "fast"
      @is_first_run_slide = false
      return null
    ###

    if now is 0 and where is (cells.size() - 1)
      cells.eq(where).show().css left: -dis

      cells.eq(now).stop().animate
        left: dis

      cells.eq(where).stop().animate
        left: 0

      return null
    
    if where > now
      cells.eq(where).show().css left: dis

      cells.eq(now).stop().animate
        left: -dis

      cells.eq(where).stop().animate
        left: 0

      return null

    if where is 0 and now is (cells.size() - 1)
      cells.eq(where).show().css left: dis

      cells.eq(now).stop().animate
        left: -dis

      cells.eq(where).stop().animate
        left: 0

      return null

    if where < now
      cells.eq(where).show().css left: -dis

      cells.eq(now).stop().animate
        left: dis

      cells.eq(where).stop().animate
        left: 0

      return null
  
# END define
