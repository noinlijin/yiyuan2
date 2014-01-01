# Zonda Tool
# Deploy the HTML Fragments within Zonda's CSS/JS
# - - -

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"
Mustache = require "mustache"
exec = require('child_process').exec

# Welcome
# - - -
console.log "\n\n Zonda Tool".bold + ":  Deploy..."

project_dir = path.resolve './', '../'

CONFIG = require "#{project_dir}/etc/zonda.yml"

deploy_map = CONFIG.deploy_map

# Main Function
# - - -
Deploy = ( rel_path, frag_name ) ->
  deploy_dir = path.resolve project_dir, rel_path

  console.log "\n   Deploying: ".bold + "#{deploy_dir}/" + " #{frag_name}".bold.yellow + "..."

  try
    tpl = fs.readFileSync "#{project_dir}/tool/deploy_fragment/#{frag_name}", encoding: "utf8"

    res_content = Mustache.render tpl, CONFIG: CONFIG

    fs.writeFileSync "#{deploy_dir}/#{frag_name}", res_content

    console.log "   >>".bold + " Success!".green
  catch err
    console.log "   >>".bold + " Error!".red.inverse
    console.log "   >>".bold + " #{err}".red.inverse.bold

# END Deploy

# Deploy all fragment
# - - -
for frag_name, rel_path of deploy_map
  Deploy rel_path, frag_name
