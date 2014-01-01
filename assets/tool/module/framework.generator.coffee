# Zonda Tool
# Generator of the dist/framework-version.js
# - - -
# When project pattern is "dev",
# concat the sea.js, some seajs plugin, seajs_config in the framework.js
#
# When project pattern is "prod",
# concat the sea.js, some seajs plugin, seajs_config in the framework.js
# concat all vendor and util into framework.js

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  Generate framework..."

project_dir = path.resolve './', '../'

CONFIG = require "#{project_dir}/etc/zonda.yml"

# Mkdir dist
# - - -
try
  fs.readdirSync "#{project_dir}/dist"
catch err
  fs.mkdirSync "#{project_dir}/dist" if err isnt null

# Generate simple framework
# - - -
# Combo Seajs, Seajs Plugin, Seajs Config
console.log "\n   Generate simple framework-#{CONFIG.version}.js...:  ".bold

sea = fs.readFileSync "#{project_dir}/vendor/Zonda/vendor/sea/#{CONFIG.sea_version}/sea-debug.js"

sea_plugin_text = fs.readFileSync "#{project_dir}/vendor/Zonda/vendor/sea/#{CONFIG.sea_version}/seajs-text-debug.js"

sea_config = fs.readFileSync "#{project_dir}/etc/seajs_config.js"

fs.writeFileSync "#{project_dir}/dist/framework-#{CONFIG.version}.js", sea+sea_plugin_text+sea_config

console.log "   >>".bold + " Success!".green

# Generate Combo framework
# - - -
# Combo all vendor into framework

if CONFIG.pattern is "prod"
  zonda_vendor_dir = "vendor/Zonda/vendor"

  aliasGenerator = require "./alias.generator"
  vendor_list = aliasGenerator "#{project_dir}/#{zonda_vendor_dir}", zonda_vendor_dir

  console.log "\n   Combo vendors into framework-#{CONFIG.version}.js...:  ".bold

  for name of vendor_list.dependencies
    console.log "\n     Combining: ".bold + "#{name}" + "[#{vendor_list.info[name]}]".yellow
    _vendor_content = fs.readFileSync "#{project_dir}/#{vendor_list.alias[name]}.js"
    fs.appendFileSync "#{project_dir}/dist/framework-#{CONFIG.version}.js", _vendor_content
    console.log "     >>".bold + " Success!".green
  # END for

# END if

console.log "\n\n Zonda Tool".bold + " >> " + "Generate framework-#{CONFIG.version}.js" + " Success!\n".bold.yellow
