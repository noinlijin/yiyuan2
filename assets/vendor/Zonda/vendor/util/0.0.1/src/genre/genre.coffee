# Zonda Util Genre System
# - - -

define ( require, exports, module ) ->
  _ = require "underscore"

  Exception = require "../exception/exception"

  # Typeof
  # - - -
  getType = (target) ->
    Object::toString.call target

  class Genre
    constructor: ( @NAME, @API ) ->
      @GENRE = {}

      @recursive @API.genre, ( key, value, position ) =>
        # Generate the real key of Genre
        # - - -
        position = (position.replace /\s*/g, "").split "/"
        alias_position = _.clone position

        _.each position, ( cell, index ) ->

          position[index] = (cell.split "~")[0]

          # For remote_name
          # - - -
          alias_position[index] = do ->
            name_list = (((cell.split ":")[0]).split "~")
            if name_list.length < 2
              return name_list[0]
            else
              return name_list[1]
          # - - -
          # For remote_name

        # END _.each

        position = position.join "/"
        alias_position = alias_position.join "/"

        # - - -
        # Generate the real key of Genre

        # Generate the @GENRE
        # - - -
        key = key.replace /\s*/g, ""

        info = key.split ":"

        @GENRE[position] =
          local_name: (info[0].split "~")[0]
          remote_name: (info[0].split "~")[1]

          genre: info[1].replace /^@/g, ""

          essential_act: do ->

        @GENRE[alias_position] = @GENRE[position]
        # - - -
        # Generate the @GENRE

    recursive: ( source, action, position ) ->
      # If we want to inspect some key in "Object A" by the Genre System,
      # We shall know which key in Genre System is mapping to "Object A".
      # So, we must know where we are, then I try to use the "position" to resolve.
      top = if @NAME then @NAME else "TOP"
      position = top unless position

      # Object
      # - - -
      if "[object Object]" is getType source
        result = {}

        _.each source, ( value, key ) =>
          here = "#{position}/#{key}"

          # "action" may modify the key
          # - - -
          mod_key = action key, value, here

          key = mod_key if mod_key
          # - - -
          # "action" may modify the key

          result[key] = value

          if ("[object Object]" is getType value) or ("[object Array]" is getType value)
            result[key] = @recursive value, action, here
        # END _.each

        return result
      # - - -
      # Object

      # Array
      # - - -
      if "[object Array]" is getType source
        result = []

        _.each source, ( el, key ) =>
          #result.push @recursive el, action, "#{position}:[#{key}]"
          result.push @recursive el, action, "#{position}/[]"

        return result
      # - - -
      # Array

      # Other
      # - - -
      return source
      # - - -
      # Other

    genre_map:
      "Function": "[object Function]"
      "Object": "[object Object]"
      "Array": "[object Array]"
      "Number": "[object Number]"
      "String": "[object String]"

    inspect: ( source, act ) ->
      genre = _.clone @GENRE

      @recursive source, ( key, value, position ) =>
        return null unless @GENRE[position]

        if @genre_map[@GENRE[position].genre] isnt getType value
          Exception "genre",
            position: position
            expect: @genre_map[@GENRE[position].genre]
            not: getType value

        else
          genre[position].is_inspected = true

      return true
      # END @recursive

    modifyKey: ( source, direction ) ->
      return @recursive source, ( key, value, position ) =>
        if @GENRE[position]
          return @GENRE[position][direction]

    toLocal: (source) -> @modifyKey source, "local_name"

    toRemote: (source) -> @modifyKey source, "remote_name"

  module.exports = Genre
  
# END define
