$ ->
  return unless $("body.controller_customers").length > 0
  
  if $("body.action_new").length > 0 || $("body.action_edit").length > 0 || $("body.action_index")
    $("#customer_name").focus()
