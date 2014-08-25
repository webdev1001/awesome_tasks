$ ->
  return unless $("body.controller_frontpage").length > 0

  $(".task-list .task-row input[type=checkbox]").change ->
    check = $(this)
    row = check.closest(".task-row")

    post_data = {task: {state: "closed"}}

    $.ajax type: "PATCH", url: row.data("task-path"), data: post_data, dataType: "json", success: (data) ->
      if data.success
        $("td", row).fadeOut "fast", ->
          row.remove()
      else
        alert data.errors


