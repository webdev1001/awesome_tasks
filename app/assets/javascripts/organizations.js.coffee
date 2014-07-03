$ ->
  return unless $("body.controller_organizations").length > 0
  
  if $("body.action_new").length > 0 || $("body.action_edit").length > 0 || $("body.action_index")
    $("#organization_name").focus()
