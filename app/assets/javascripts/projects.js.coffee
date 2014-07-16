$ ->
  return unless $("body.controller_projects").length > 0

  if $("body.action_index").length > 0
    $("#project_name").focus()

  if $("body.action_new").length > 0 || $("body.action_edit").length > 0
    $("#project_name").focus()

  if $("body.action_show").length > 0
    $(".assign-user-button").click ->
      modal({title: $(this).data("title"), url: $(this).data("url")})

  window.load_assigned_users = ->
    assigned_users_url = $(".project_table").data("assigned-users-path")

    $.ajax({type: "GET", url: assigned_users_url, async: true, cache: false, complete: (data) ->
      $("#divassignedusers").slideUp("fast", ->
        $("#divassignedusers").html(data.responseText)
        $("#divassignedusers").slideDown("fast")
      )
    })

  window.project_show_assign_user_choose = (user_id) ->
    project_id = $(".project_table").data("project-id")
    modal_close()
    project_assign_user(project_id, user_id)

  events.connect("do_project_assigned_users_update", ->
    load_assigned_users()
  )
