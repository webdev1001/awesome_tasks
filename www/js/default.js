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
  modal({title: locale_strings["timelog_edit_title"], height: 600, url: "clean.rhtml?show=timelog_edit&timelog_id=" + tlog_id});
}

function timelog_add(task_id){
  modal({title: locale_strings["timelog_edit_title"], height: 600, url: "clean.rhtml?show=timelog_edit&task_id=" + task_id});
}

function task_removed_assigned(link_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=task_show&choice=removeassigned&link_id=" + link_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_task_assigned_users_update");
  }});
}

function task_check_edit(check_id){
  modal({title: locale_strings["task_check_edit_title"], url: "clean.rhtml?show=task_check_edit&check_id=" + check_id});
}

function task_check_delete(check_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=task_check_edit&choice=dodelete&check_id=" + check_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_task_check_update");
  }});
}

function task_check_set(check_id, val){
  if (val == "on"){
    val = 1;
  }
  
  $.ajax({type: "GET", url: "clean.rhtml?show=task_check_edit&choice=setcheck&check_id=" + check_id + "&checkval=" + val, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
  }});
}