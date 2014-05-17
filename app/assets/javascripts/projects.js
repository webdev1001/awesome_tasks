function project_remove_assigned_user(link_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=project_show&choice=doremoveassigneduser&link_id=" + link_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_project_assigned_users_update");
  }});
}

function project_assign_user(project_id, user_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=project_show&choice=doassignuser&project_id=" + project_id + "&user_id=" + user_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_project_assigned_users_update");
  }});
}
