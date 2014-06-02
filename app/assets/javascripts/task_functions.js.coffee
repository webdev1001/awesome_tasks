window.task_remove_assigned = (link_id) ->
  $.ajax({type: "DELETE", url: "/task_assigned_users/" + link_id, cache: false, async: true, complete: (data) ->
    alert(data.responseText) if $.trim(data.responseText).length > 0
    events.call("do_task_assigned_users_update")
  })

window.task_check_edit = (task_id, check_id) ->
  modal({title: locale_strings["task_check_edit_title"], url: "/tasks/" + task_id + "/task_checks/" + check_id + "/edit"})

window.task_check_delete = (task_id, check_id) ->
  $.ajax({type: "DELETE", url: "/tasks/" + task_id + "/task_checks/" + check_id, cache: false, async: true, complete: (data) ->
    alert(data.responseText) if data.responseText.length > 0
    events.call("do_task_check_update")
  })

window.task_check_set = (task_id, check_id, val) ->
  $.ajax({type: "PUT", url: "/tasks/" + task_id + "/task_checks/" + check_id, data: {task_check: {checked: val}}, cache: false, async: true, complete: (data) ->
    alert(data.responseText) if $.trim(data.responseText).length > 0
  })
