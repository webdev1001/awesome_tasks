$ ->
  return unless $("body.controller_tasks").length > 0

  $(".add_to_list").click ->
    user_task_list_link_add($(this).data("task-id"))
    location.reload()

  $(".remove_from_list").click ->
    if confirm($(this).data("confirm-msg"))
      user_task_list_link_remove($(this).data("link-id"))
      location.reload()

  $("#task_name").focus() if $("body.action_index").length > 0

  if $("body.action_edit").length > 0 || $("body.action_new").length > 0
    $("#task_name").focus()

    insert_browser_and_os = ->
      @browser_and_os_inserted = true

      form = $("form")

      ck = CKEDITOR.instances.task_description;
      ck.insertHtml("<b>" + form.data("browser-key") + ":</b> " + form.data("browser-value") + "<br />")
      ck.insertHtml("<b>" + form.data("version-key") + ":</b> " + form.data("version-value") + "<br />")
      ck.insertHtml("<b>" + form.data("os-key") + ":</b> " + form.data("os-value") + "<br />")

    @browser_and_os_inserted = false
    $("#task_task_type").change ->
      insert_browser_and_os() if this.value == "bug" && !@browser_and_os_inserted

  $(".button-insert-browser-and-os").click (e) ->
    e.preventDefault()
    insert_browser_and_os()

  if $("body.action_show").length > 0
    task_show = $(".task_show")

    window.task_show_comments_update = ->
      $.ajax type: "GET", url: task_show.data("comments-task-path"), async: true, cache: false, complete: (data) ->
        $("#divcomments").slideUp "fast", ->
          $("#divcomments").html(data.responseText)
          $("#divcomments").slideDown("fast")

    window.task_show_timelogs_update = ->
      $.ajax type: "GET", url: task_show.data("timelogs-task-path"), async: true, cache: false, complete: (data) ->
        $("#divtimelogs").slideUp "fast", ->
          $("#divtimelogs").html(data.responseText)
          $("#divtimelogs").slideDown("fast")

    window.task_show_users_update = ->
      $.ajax type: "GET", url: task_show.data("users-task-path"), async: true, cache: false, complete: (data) ->
        $("#divusers").slideUp "fast", ->
          $("#divusers").html(data.responseText)
          $("#divusers").slideDown("fast")

    window.task_show_assign_user_choose = (user_id) ->
      $.ajax type: "POST", url: task_show.data("assign-user-task-path"), data: {"user_id": user_id}, async: true, cache: false, dataType: "json", success: (data) ->
        alert(data.errors) unless data.success
        task_show_users_update()
        modal_close()

    window.task_show_checks_update = ->
      $.ajax type: "GET", url: task_show.data("checks-task-path"), async: true, cache: false, complete: (data) ->
        $("#divchecks").slideUp "fast", ->
          $("#divchecks").html(data.responseText)
          $("#divchecks").slideDown("fast")

    $(".assign_user_to_task").click (e) ->
      e.preventDefault()
      modal_on_opened -> $("#user_name").focus()
      modal({title: $(this).data("title"), url: $(this).data("url")})

    $(".add_new_check").click (e) ->
      e.preventDefault()
      modal_on_opened -> $("#task_check_name").focus()
      modal({title: $(this).data("title"), url: $(this).data("url")})

    $("body").on "ajax:success", ".new_task_check, .edit_task_check", (data) ->
      events.call("on_task_check_added")
      events.call("do_task_check_update")
      modal_close()

    $("body").on "change", "input.task_check", ->
      task_check_set $(this).data("task-id"), $(this).data("task-check-id"), $(this).is(":checked")

    $("body").on "click", ".task_check_edit", ->
      task_check_edit $(this).data("task-id"), $(this).data("task-check-id")

    $("body").on "click", ".task_check_delete", ->
      task_check_delete $(this).data("task-id"), $(this).data("task-check-id") if confirm $(this).data("confirm-msg")

    $("body").on "click", ".remove_user", ->
      task_remove_assigned($(this).data("link-id")) if confirm $(this).data("confirm-msg")

    $('.add-new-comment-button').click (e) ->
      e.preventDefault()
      comment_new('Task', $(this).data('task-id'))

    events.connect "do_comments_update", -> task_show_comments_update()
    events.connect "do_timelogs_update", -> task_show_timelogs_update()
    events.connect "do_task_assigned_users_update", -> task_show_users_update()
    events.connect "do_task_check_update", -> task_show_checks_update()

    # Makes the task new/edit modal behave
    events.connect 'on_comments_new', ->
      modal_on_opened ->
        form = $('form.new_comment, form.edit_comment')
        form.data('remote', 'true')
        form.data('type', 'json')

        form.bind 'ajax:error', (evt, xhr, status, error) ->
          json = $.parseJSON(xhr.responseText)
          alert(json.errors)

        form.bind 'ajax:success', (evt, xhr, status) ->
          task_show_comments_update()
          modal_close()
