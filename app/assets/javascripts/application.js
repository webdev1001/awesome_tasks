// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-migrate-min
//= require comments
//= require projects
//= require tasks
//= require timelogs
//= require knjjsfw/jquery.md5
//= require knjjsfw/events
//= require knjjsfw/forms
//= require knjjsfw/select
//= require knjjsfw/modal
//= require knjjsfw/includes/jquery.simplemodal-1.4.1.js

var events = null

$(document).ready(function(){
  events = new Events()
  
  modal_setup({
    url: js_settings["knjjs_url"],
    css: {
      "border": "3px solid #4e4e4e",
      "background-color": "#f6f6f6",
      "padding": "10px",
      "padding-top": "0px",
      "padding-bottom": "14px",
      "width": "700px",
      "height": "700px",
      "overflow": "auto"
    },
    css_header: {
      "font-size": "16px",
      "font-weight": "bold",
      "padding-bottom": "7px",
      "padding-top": "5px",
      "color": "#000000"
    }
  });
});
