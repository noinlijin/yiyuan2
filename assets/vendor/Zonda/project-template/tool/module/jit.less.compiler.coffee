# Zonda Tool
# JIT Less Compiler
# - - -
# Compile less to css when files changed

require "js-yaml"
colors = require "colors"
fs = require 'fs'
exec = require('child_process').exec
path = require 'path'
recursivePath = require "./path.recursive"

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  JIT Less Compiler Running..."

# Command of Less
# - - -
lessc_command = "lessc -x"

# Path config
# - - -
project_dir = path.resolve './', '../'
CONFIG = require "#{project_dir}/etc/zonda.yml"

output_dir = "#{project_dir}/dist"
input_dir = "#{project_dir}/ui/less"
main_file = "#{CONFIG.less_compiler.bootstrap}.less"

# Queue
# - - -
# Queue of file Compiling
queue = {}

# Compile
# - - -
# invoke lessc to compile
Compile = (file, callback)->
  command = "#{lessc_command} #{file} > #{output_dir}/#{CONFIG.less_compiler.destination}-#{CONFIG.version}.css"

  exec command, encoding: "", callback
# END compiler

# Main
# - - -
# compiler
Main = ( file_name, file_path ) ->

  if not /\.less$/.test file_name
    return false

  # Queue ID
  # - - -
  id = (file_path.replace input_dir, "") + file_name

  # Check the Queue
  # - - -
  if queue[id] is undefined
    queue[id] = "compiling"
  else
    return null

  base_name = path.basename file_name, ".less"

  console.log "\n   <- ".bold + "compiling:".green
  console.log "     #{file_path.replace input_dir, "" }" + " #{file_name}".yellow

  # At first, try to compile main file
  # - - -
  Compile "#{input_dir}/#{main_file}", ( err, stdout, stderr ) ->
    # Remove this file from Queue
    # - - -
    delete queue[id]

    if err isnt null
      console.log "   >>".bold + " Error!".red.inverse
      console.log "     #{err}"
      
    else
      #console.log "   >>".bold + " Success!".green + "#{file_path.replace input_dir, "" }" + " #{file_name}".yellow
      console.log "   >>".bold + " Success!".green + " no errro."

# END main

Main main_file, "#{input_dir}"

# watch the input_dir
recursivePath "#{input_dir}", ( type, path_cell ) ->
  if type is "dir"
    fs.watch path_cell.realpath, ( event, name ) ->
      if event is "change"
        Main name, path_cell.realpath
, 10

fs.watch "#{input_dir}", ( event, name ) ->
  if event is "change"
    Main name, "#{input_dir}"

module.exports = Main
