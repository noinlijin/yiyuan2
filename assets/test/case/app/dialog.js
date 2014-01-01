// Generated by CoffeeScript 1.6.2
define(function(require) {
  var Dialog, Util;

  module("Dialog");
  Util = require("util");
  Dialog = Util.Dialog;
  test("API", function() {
    ok(Dialog.open);
    ok(Dialog.close);
    strictEqual(typeof Dialog.open, "function");
    return strictEqual(typeof Dialog.close, "function");
  });
  test("Dialog Render", function() {
    Dialog({
      title: "small",
      content: "big",
      button: {
        "hehe": function() {}
      }
    }).open();
    ok(Dialog.$dom[0]);
    strictEqual(Dialog.$dom.find(".modal-header h3").text(), "small");
    ok(/big/.test(Dialog.$dom.find(".modal-body").text()));
    ok(/hehe/.test(Dialog.$dom.find(".modal-footer button[id]").text()));
    return Dialog.close();
  });
  test("Dialog Style", function() {
    Dialog.close();
    Dialog({
      title: "small",
      content: "big",
      "class": "haha",
      button: {
        "hehe": function() {}
      }
    }).open();
    ok(Dialog.$dom.hasClass("haha"));
    return Dialog.close();
  });
  asyncTest("Dialog button callback", function() {
    var num;

    Dialog.close();
    num = 1;
    Dialog({
      title: "small",
      content: "big",
      "class": "haha",
      button: {
        "hehe": function() {
          return num = 2;
        }
      }
    }).open();
    Dialog.$dom.find(".modal-footer button.btn-success").trigger("click");
    return setTimeout(function() {
      strictEqual(num, 2);
      ok(Dialog.$dom.find(".modal-footer button.btn-success").hasClass("disabled"));
      return start();
    }, 300);
  });
  asyncTest("Dialog button for cancel", function() {
    Dialog.close();
    Dialog({
      title: "small",
      content: "big"
    }).open();
    Dialog.$dom.find(".modal-footer button[aria-hidden=true]").trigger("click");
    return setTimeout(function() {
      var id;

      id = Dialog.$dom.attr("id");
      ok(!$("#" + id)[0]);
      return start();
    }, 300);
  });
  asyncTest("Dialog Close Delay", function() {
    Dialog.close();
    Dialog({
      title: "small",
      content: "big"
    }).open();
    Dialog.close(400);
    return setTimeout(function() {
      var id;

      id = Dialog.$dom.attr("id");
      ok(!$("#" + id)[0]);
      return start();
    }, 400);
  });
  asyncTest("Dialog Config", function() {
    Dialog.close();
    Dialog({
      title: "small",
      content: "big"
    }).open();
    Dialog.close(400);
    return setTimeout(function() {
      deepEqual(Dialog.config, {
        title: "small",
        content: "big"
      });
      return start();
    }, 400);
  });
  return asyncTest("Chain Style", function() {
    Dialog.close();
    Dialog({
      title: "small",
      content: "big"
    }).open().close(400);
    return setTimeout(function() {
      var id;

      id = Dialog.$dom.attr("id");
      ok(!$("#" + id)[0]);
      return start();
    }, 400);
  });
});
