var events = new Events();

$(document).ready(function(){
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

function comment_delete(comment_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=comment_edit&choice=dodelete&comment_id=" + comment_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_comments_update");
  }});
}

function comment_edit(comment_id){
  modal({title: locale_strings["comment_edit_title"], url: "clean.rhtml?show=comment_edit&comment_id=" + comment_id});
}

function timelog_delete(tlog_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=timelog_edit&choice=dodelete&timelog_id=" + tlog_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_timelogs_update");
  }});
}

function timelog_edit(tlog_id){
  modal({title: locale_strings["timelog_edit_title"], url: "clean.rhtml?show=timelog_edit&timelog_id=" + tlog_id});
}