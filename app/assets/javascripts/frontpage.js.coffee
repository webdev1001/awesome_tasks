$ ->
  return unless $("body.controller_frontpage").length > 0

  table_list = $("table.task-list")

  $(".task-row input[type=checkbox]", table_list).change ->
    check = $(this)
    row = check.closest(".task-row")

    comment_data = {
      comment: {
        resource_type: "Task"
        resource_id: row.data("task-id")
        comment: table_list.data("close-msg")
      }
      task: {
        state: "closed"
      }
    }

    $.ajax type: "POST", url: table_list.data("create-comment-path"), data: comment_data, dataType: "json", success: (data) ->
      if data.success
        $("td", row).fadeOut "fast", ->
          row.remove()
      else
        alert data.errors


