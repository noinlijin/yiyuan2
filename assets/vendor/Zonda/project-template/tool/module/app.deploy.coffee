# Zonda Tool
# Deploy the app
# - - -

require "js-yaml"
fs = require "fs"
path = require "path"
colors = require "colors"

project_dir = path.resolve './', '../'

CONFIG = require "#{project_dir}/etc/zonda.yml"
