# Zonda Tool
# Generator of the dist/app-version.js
# - - -

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"
exec = require('child_process').exec

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  Generate app..."

project_dir = path.resolve './', '../'

CONFIG = require "#{project_dir}/etc/zonda.yml"

# Mkdir dist
# - - -
try
  fs.readdirSync "#{project_dir}/dist"
catch err
  fs.mkdirSync "#{project_dir}/dist" if err isnt null

# Generate app depends on CONFIG.pattern
# - - -
switch CONFIG.pattern
  when "dev"
    console.log "\n   Generate simple #{CONFIG.app_bootstrap}-#{CONFIG.version}.js...:  ".bold
    fs.writeFileSync "#{project_dir}/dist/#{CONFIG.app_bootstrap}-#{CONFIG.version}.js", """
      seajs.use("#{CONFIG.web_root}/src/#{CONFIG.app_bootstrap}");
      """
    console.log "   >>".bold + " Success!".green
    console.log "\n\n Zonda Tool".bold + " >> " + "Generate App" + " Success!\n".bold.yellow

  when "prod"
    console.log "\n   Generate combo #{CONFIG.app_bootstrap}-#{CONFIG.version}.js...:  ".bold
    exec "cd #{project_dir}/ && grunt build", encoding: "", ( err, stdout, stderr ) ->
      if err isnt null
        console.log "   >>".bold + " Error!".red.inverse
        console.log "     >>".bold + err
        return null

      # Generate a new combo app
      # - - -
      _app_content = fs.readFileSync "#{project_dir}/dist/.build/#{CONFIG.app_bootstrap}.js"
      fs.writeFileSync "#{project_dir}/dist/#{CONFIG.app_bootstrap}-#{CONFIG.version}.js", _app_content
      fs.appendFileSync "#{project_dir}/dist/#{CONFIG.app_bootstrap}-#{CONFIG.version}.js", """
        ;seajs.use("#{CONFIG.app_bootstrap}");
      """
      console.log "   >>".bold + " Success!".green
      console.log "\n\n Zonda Tool".bold + " >> " + "Generate App" + " Success!\n".bold.yellow
