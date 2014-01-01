# Zonda Tool
# Generator of vendor and util's alias
# - - -
# Parameter:
# @vendor_root_dir: the realpath of vendor dir
# @relative_root_dir: the relativepath of vendor dir
#
# Return:
# list the vendor dir, return a object like this:
###
alias = {
  "jquery": "vendor/Zonda/vendor/jquery/1.9.1/jquery",
  "underscore": "vendor/Zonda/vendor/underscore/1.4.4/underscore"
}
###

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"

project_dir = path.resolve './', '../'

CONFIG = require "#{project_dir}/etc/zonda.yml"

main = ( vendor_root_dir, relative_root_dir ) ->
  console.log "\n   Scanning the vendor/..."

  alias = {}
  dependencies = {}
  info = {}

  list = fs.readdirSync vendor_root_dir

  for vendor_name in list
    version_list = fs.readdirSync "#{vendor_root_dir}/#{vendor_name}"

    # Just use the first version, the only one!
    # - - -
    if CONFIG.pattern is "dev"
      alias[vendor_name] = "#{relative_root_dir}/#{vendor_name}/#{version_list[0]}/src/#{vendor_name}"
      dependencies[vendor_name] = "#{vendor_name}"
      info[vendor_name] = "#{version_list[0]}"
    else
      alias[vendor_name] = "#{relative_root_dir}/#{vendor_name}/#{version_list[0]}/#{vendor_name}"
      dependencies[vendor_name] = "#{vendor_name}"
      info[vendor_name] = "#{version_list[0]}"

  console.log "   >>".bold + " Success!".green

  # Remove SeaJS
  # - - -
  delete alias.sea
  delete dependencies.sea
  delete info.sea

  return {
    alias : alias
    dependencies : dependencies
    info: info
  }

# END main

module.exports = main
