// Generated by CoffeeScript 1.6.3
(function() {
  define(function(require, exports, module) {
    var ALIAS, Cell, Wrap, filter;
    filter = function(attrs) {
      var attr, key, name, tasks;
      tasks = {};
      for (key in attrs) {
        attr = attrs[key];
        if (typeof attr !== "object") {
          continue;
        }
        if (attr === null) {
          continue;
        }
        name = attr.name.toLowerCase();
        if (!/^task-/.test(name)) {
          continue;
        }
        name = name.replace(/^task-/, "");
        tasks[name] = attr.value;
      }
      return tasks;
    };
    ALIAS = {
      "INPUT:text": "text",
      "INPUT:password": "password",
      "INPUT:radio": "radio",
      "INPUT:checkbox": "checkbox",
      "TEXTAREA": "textarea",
      "SELECT": "select"
    };
    Wrap = function(form) {
      var cells, sel, type;
      cells = [];
      for (sel in ALIAS) {
        type = ALIAS[sel];
        $(form).find(sel).each(function() {
          return cells.push(new Cell(type, this));
        });
      }
      return cells;
    };
    Cell = (function() {
      function Cell(type, cell) {
        var attrs, value;
        this.type = type;
        attrs = cell.attributes;
        cell = $(cell);
        this.dom = cell;
        this.group_dom = this.dom.parents(".form-group");
        this.name = cell.attr("name");
        this["default"] = cell.attr("default");
        value = cell.attr("value");
        if (this["default"] !== void 0 && value === void 0) {
          cell.val(this["default"]);
        }
        this.tasks = filter(attrs);
      }

      return Cell;

    })();
    return module.exports = Wrap;
  });

}).call(this);
