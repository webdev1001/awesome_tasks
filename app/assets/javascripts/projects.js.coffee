$ ->
  return unless $("body.controller_projects").length > 0
  
  if $("body.action_index").length > 0
    $("#project_name").focus()
  
  if $("body.action_new").length > 0 || $("body.action_edit").length > 0
    $("#project_name").focus()
