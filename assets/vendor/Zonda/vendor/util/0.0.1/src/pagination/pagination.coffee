# Zonda Util Pagination
# - - -
define ( require, exports, module ) ->

  module.exports = ( now, total, prefix ) ->
    prefix = "" unless prefix

    result = ""

    # First
    # - - -
    if now isnt 1 and total >= 4
      result = result + """
        <li>
          <a href="##{prefix}/page=1">第一页</a>
        </li>
      """
  
    # Prev
    # - - -
    if now isnt 1 and total > 2
      result = result + """
        <li>
          <a href="##{prefix}/page=#{now-1}">上一页</a>
        </li>
      """
    else
      result = result + """
        <li class="disabled">
          <a href="javascript:;">上一页</a>
        </li>
      """

    # Left 2 pages
    # - - -
    if now isnt 1
      do ->
        for page in [now-2..now-1]
          continue unless page > 0
          result = result + """
            <li>
              <a href="##{prefix}/page=#{page}">#{page}</a>
            </li>
          """

    # Middle with now
    # - - -
    result = result + """
      <li class="disabled">
        <a href="javascript:;">#{now}</a>
      </li>
    """

    # Right 2 pages
    # - - -
    if now isnt total
      do ->
        for page in [now+1..now+2]
          continue unless page <= total
          result = result + """
            <li>
              <a href="##{prefix}/page=#{page}">#{page}</a>
            </li>
          """

    # Next
    # - - -
    if now isnt total and total > 2
      result = result + """
        <li>
          <a href="##{prefix}/page=#{now+1}">下一页</a>
        </li>
      """
    else
      result = result + """
        <li class="disabled">
          <a href="javascript:;">下一页</a>
        </li>
      """

    # Last
    # - - -
    if now isnt total and total >= 4
      result = result + """
        <li>
          <a href="##{prefix}/page=#{total}">最后一页</a>
        </li>
      """

    # Wrap
    # - - -
    return """<ul class="pagination">#{result}</ul>"""

# END define
