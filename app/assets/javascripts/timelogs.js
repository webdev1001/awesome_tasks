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
