@user_task_list_link_add = (task_id)->
  $.ajax({type: "POST", url: "/user_task_list_links", data: {"user_task_list_link": {"task_id": task_id}}, async: false, cache: false, complete: (data)->
    alert(data.responseText) if $.trim(data.responseText).length > 0
  })

@user_task_list_link_remove = (link_id)->
  $.ajax({type: "DELETE", url: "/user_task_list_links/" + link_id, async: false, cache: false, complete: (data)->
    alert(data.responseText) if $.trim(data.responseText).length > 0
  })
