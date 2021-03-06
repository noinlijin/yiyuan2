// Generated by CoffeeScript 1.6.3
var CONFIG, Deploy, Mustache, colors, deploy_map, exec, frag_name, fs, path, project_dir, rel_path;

require("js-yaml");

fs = require("fs");

path = require("path");

colors = require("colors");

Mustache = require("mustache");

exec = require('child_process').exec;

console.log("\n\n Zonda Tool".bold + ":  Deploy...");

project_dir = path.resolve('./', '../');

CONFIG = require("" + project_dir + "/etc/zonda.yml");

deploy_map = CONFIG.deploy_map;

Deploy = function(rel_path, frag_name) {
  var deploy_dir, err, res_content, tpl;
  deploy_dir = path.resolve(project_dir, rel_path);
  console.log("\n   Deploying: ".bold + ("" + deploy_dir + "/") + (" " + frag_name).bold.yellow + "...");
  try {
    tpl = fs.readFileSync("" + project_dir + "/tool/deploy_fragment/" + frag_name, {
      encoding: "utf8"
    });
    res_content = Mustache.render(tpl, {
      CONFIG: CONFIG
    });
    fs.writeFileSync("" + deploy_dir + "/" + frag_name, res_content);
    return console.log("   >>".bold + " Success!".green);
  } catch (_error) {
    err = _error;
    console.log("   >>".bold + " Error!".red.inverse);
    return console.log("   >>".bold + (" " + err).red.inverse.bold);
  }
};

for (frag_name in deploy_map) {
  rel_path = deploy_map[frag_name];
  Deploy(rel_path, frag_name);
}
