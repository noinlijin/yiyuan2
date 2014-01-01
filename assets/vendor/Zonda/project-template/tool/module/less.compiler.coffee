# Zonda Tool
# Simple Less to CSS Compiler
# - - -
# Compile less to css once!

require "js-yaml"
colors = require "colors"
fs = require 'fs'
exec = require('child_process').exec
path = require 'path'
recursivePath = require "./path.recursive"

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  Simple Less Compiler Running..."

# Path config
# - - -
project_dir = path.resolve './', '../'
CONFIG = require "#{project_dir}/etc/zonda.yml"

output_dir = "#{project_dir}/dist"
input_dir = "#{project_dir}/ui/less"
main_file = "#{CONFIG.less_compiler.bootstrap}.less"

# Command of Less
# - - -
lessc_command = "lessc -x "

command = "#{lessc_command} #{input_dir}/#{main_file} > #{output_dir}/#{CONFIG.less_compiler.destination}-#{CONFIG.version}.css"

exec command, encoding: "", (err)->
  if err isnt null
    console.log "   >>".bold + " Error!".red.inverse
    console.log "     #{main_file}".yellow
    console.log "     #{err}"
    
  else
    console.log "   >>".bold + " Success: ".green + "#{CONFIG.less_compiler.destination}-#{CONFIG.version}".yellow
    console.log "\n\n Zonda Tool".bold + " >> " + "Generate #{CONFIG.less_compiler.destination}-#{CONFIG.version}.css" + " Success!\n".bold.yellow
