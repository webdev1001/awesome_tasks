$ ->
  if $("body.controller_projects").length > 0
    $(".remove_autoassigned_user_path").bind "ajax:success", ->
      location.reload()
