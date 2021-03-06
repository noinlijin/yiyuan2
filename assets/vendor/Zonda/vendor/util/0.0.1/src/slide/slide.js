// Generated by CoffeeScript 1.6.2
define(function(require, exports, module) {
  var $, Backbone, Page, Slide, _;

  $ = require("jquery-ui");
  _ = require("underscore");
  Backbone = require("backbone");
  Page = require("./page");
  Slide = (function() {
    function Slide(config) {
      var _this = this;

      this.config = config;
      _.extend(this, Backbone.Events);
      this.cells = $(config.sel).children();
      this.length = this.cells.size();
      this.now = {
        index: 0,
        dom: this.cells.first()
      };
      if (!this.config.trans) {
        this.config.trans = "fade";
      }
      if (!this.config.delay) {
        this.config.delay = 1000;
      }
      if (!this.config.autoPlay) {
        this.config.autoPlay = true;
      }
      this.now.dom.fadeIn("fast");
      if (this.length <= 1) {
        return null;
      }
      if (config.page) {
        Page.call(this, config);
      }
      this.autoPlay(0);
      this.cells.on("mouseover", function() {
        return _this.stop();
      });
      this.cells.on("mouseout", function() {
        return _this.autoPlay();
      });
    }

    Slide.prototype.goto = function(where) {
      var old;

      clearTimeout(this.timer);
      if (this.length <= 1) {
        return null;
      }
      if (where < 0) {
        where = this.length + where;
      }
      if (where >= this.length) {
        where = where - this.length;
      }
      this.trans[this.config.trans](where, this.now.index, this.cells);
      old = this.now;
      this.now = {
        index: where,
        dom: this.cells.eq(where)
      };
      return this.trigger("" + this.config.sel + ":goto:slide:success", this.now, old);
    };

    Slide.prototype.timer = "";

    Slide.prototype.autoPlay = function(init) {
      var where,
        _this = this;

      if (!this.config.autoPlay) {
        return null;
      }
      if (init === void 0) {
        where = this.now.index + 1;
      } else {
        where = init;
      }
      return this.timer = setTimeout(function() {
        _this.goto(where);
        return _this.autoPlay();
      }, this.config.delay);
    };

    Slide.prototype.next = function() {
      this.goto(this.now.index + 1);
      return this.autoPlay();
    };

    Slide.prototype.prev = function() {
      this.goto(this.now.index - 1);
      return this.autoPlay();
    };

    Slide.prototype.stop = function() {
      return this.goto(this.now.index);
    };

    Slide.prototype.trans = {
      is_first_run_slide: true,
      fade: function() {
        var fade;

        fade = require("./trans-fade");
        return fade.apply(this, arguments);
      },
      move: function() {
        var move;

        move = require("./trans-move");
        return move.apply(this, arguments);
      }
    };

    return Slide;

  })();
  return module.exports = Slide;
});
