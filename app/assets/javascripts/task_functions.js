function task_remove_assigned(link_id){
  $.ajax({type: "DELETE", url: "/task_assigned_users/" + link_id, cache: false, async: true, complete: function(data){
    if ($.trim(data.responseText).length > 0){
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
