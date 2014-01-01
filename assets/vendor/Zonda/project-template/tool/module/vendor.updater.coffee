# Zonda Tool
# Update the vendor directory
# - - -

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"
exec = require("child_process").exec

project_dir = path.resolve './', '../'

zonda_vendor_dir = "vendor/Zonda/vendor"

CONFIG = require "#{project_dir}/etc/zonda.yml"

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  Update Vendor..."

# Build one vendor
# - - -
Build = ( name, version, vendor_path ) ->
  # Handle vendor
  if vendor_path is undefined
    vendor_path = zonda_vendor_dir
    vendor_real_path = path.resolve "#{project_dir}/#{vendor_path}/#{name}/#{version}"
  # Handle Util or Other
  else
    vendor_real_path = path.resolve "#{project_dir}/#{vendor_path}"

  # Generate package.json for vendor
  # - - -
  console.log "\n   Generate package.json:".bold + " #{name}" + "[#{version}]".yellow

  pkg =
    family: "#{CONFIG.web_root}/#{vendor_path}"
    name: name
    version: version
    spm:
      output: ["#{name}.js"]

  if version is "" or version is null
    delete pkg.version
    version = "no version info".bold

  console.log "   >>".bold + " Success!".green

  fs.writeFileSync "#{vendor_real_path}/package.json", JSON.stringify pkg

  # - - -
  # Generate package.json for vendor

  # Spm2 build
  # - - -
  exec "cd #{vendor_real_path} && spm build && cp ./dist/#{name}.js ./", ( err, stdout ) ->
    if err isnt null
      console.log "\n   >>".bold + " ERROR".red.inverse + " #{name}" + "[#{version}]".yellow
      return false

    console.log "\n   >>".bold + " Build Success!".green + " #{name}" + "[#{version}]".yellow
  # - - -
  # Spm2 build

# END build

# Build all vendor
# - - -
aliasGenerator = require "./alias.generator"

vendor_list = aliasGenerator "#{project_dir}/#{zonda_vendor_dir}", zonda_vendor_dir

for name of vendor_list.info
  Build name, vendor_list.info[name]

module.exports = Build
