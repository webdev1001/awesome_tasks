$ ->
  if $(".controller_tasks").length > 0
    $(".add_to_list").click ->
      user_task_list_link_add($(this).data("task-id"))
      location.reload()
    
    $(".remove_from_list").click ->
      if confirm($(this).data("confirm-msg"))
        user_task_list_link_remove($(this).data("link-id")); location.reload()
