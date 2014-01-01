# Zonda Tool
# Generator of Configure
# - - -

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  Generate configure..."

# Cache the project directory to etc/local_path.yml
# - - -
project_dir = path.resolve './', '../'

CONFIG = require "#{project_dir}/etc/zonda.yml"

fs.writeFileSync "#{project_dir}/etc/local_path.yml", """
    # Local Project Path For Zonda Tool
    project_dir: #{project_dir}
  """
console.log "\n   Local Project Path is:  ".bold + project_dir
console.log "   Generate the " + "local_path.yml".underline + " to etc/"

console.log "\n   >> ".bold + "Project Name:  ".bold.green + "   [" + "#{CONFIG.name}".bold.yellow + "]"
console.log "\n   >> ".bold + "Project Pattern:  ".bold.green + "[" + "#{CONFIG.pattern}".bold.inverse.yellow + "]"
console.log "\n   >> ".bold + "Project Version:  ".bold.green + "[" + "#{CONFIG.version}".bold.inverse.yellow + "]"

aliasGenerator = require "./alias.generator"

zonda_vendor_dir = "vendor/Zonda/vendor"

vendor_list = aliasGenerator "#{project_dir}/#{zonda_vendor_dir}", zonda_vendor_dir

# Generate SeaJS Configure
# - - -
console.log "\n   Generating the SeaJS Configure..."

alias = JSON.stringify vendor_list.alias

if CONFIG.pattern is "dev"
  domain = CONFIG.domain_dev
else
  domain = CONFIG.domain_prod

seajs_config = """
  seajs.config({
    domain: "#{domain}",
    base: "#{CONFIG.web_root}",
    charset: "utf-8",
    alias: #{alias}
  });
"""

fs.writeFileSync "#{project_dir}/etc/seajs_config.js", seajs_config
console.log "   >>".bold + " Success!".green

# Generate Spm2 Configure
# - - -
console.log "\n   Generating the Spm2 alias..."

dependencies = JSON.stringify vendor_list.dependencies

spm_alias = dependencies

fs.writeFileSync "#{project_dir}/etc/spm_alias.json", spm_alias
console.log "   >>".bold + " Success!".green

# Generate Less Configure
# - - -
console.log "\n   Generating the path of Less..."
less_path_config = """
// Path of Web root
@root: "#{CONFIG.web_root}";

// Path of images
@img: "#{CONFIG.web_root}/#{CONFIG.image_path}";

// Path of FontAwesome Font
@FontAwesomePath: "#{CONFIG.web_root}/#{CONFIG.FontAwesomePath}";
"""

fs.writeFileSync "#{project_dir}/etc/less_path_config.less", less_path_config
console.log "   >>".bold + " Success!".green

console.log "\n\n Zonda Tool".bold + " >> " + "Generate Configure" + " Success!\n".bold.yellow
