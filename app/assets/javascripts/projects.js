function project_remove_assigned_user(link_id){
  $.ajax({type: "DELETE", url: "/user_project_links/" + link_id, cache: false, async: true, complete: function(data){
    if ($.trim(data.responseText).length > 0){
      alert(data.responseText);
    }
    
    events.call("do_project_assigned_users_update");
  }});
}

function project_assign_user(project_id, user_id){
  $.ajax({type: "POST", url: "/projects/" + project_id + "/assign_user?user_id=" + user_id, cache: false, async: true, complete: function(data){
    if ($.trim(data.responseText).length > 0){
      alert(data.responseText);
    }
    
    events.call("do_project_assigned_users_update");
  }});
}
