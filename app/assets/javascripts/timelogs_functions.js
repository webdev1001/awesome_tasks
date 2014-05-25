function timelog_delete(tlog_id){
  $.ajax({type: "DELETE", url: "/timelogs/" + tlog_id, cache: false, async: true, complete: function(data){
    if ($.trim(data.responseText).length > 0){
      alert(data.responseText);
    }
    
    events.call("do_timelogs_update");
  }});
}

function timelog_edit(tlog_id){
  modal({title: locale_strings["timelog_edit_title"], height: "550px", url: "/timelogs/" + tlog_id + "/edit"});
}

function timelog_add(task_id){
  modal({title: locale_strings["timelog_edit_title"], height: "550px", url: "/timelogs/new/?timelog[task_id]=" + task_id});
}
