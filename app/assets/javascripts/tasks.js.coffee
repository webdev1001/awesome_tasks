$ ->
  return unless $("body.controller_tasks").length > 0
  
  $(".add_to_list").click ->
    user_task_list_link_add($(this).data("task-id"))
    location.reload()
  
  $(".remove_from_list").click ->
    if confirm($(this).data("confirm-msg"))
      user_task_list_link_remove($(this).data("link-id")); location.reload()
  
  if $("body.action_index").length > 0
    $("#task_name").focus()
  
  if $("body.action_edit").length > 0 || $("body.action_new").length > 0
    $("#task_name").focus()
    
    insert_browser_and_os = ->
      @browser_and_os_inserted = true
      
      form = $("form")
      
      ck = CKEDITOR.instances.task_description;
      ck.insertHtml("<b>" + form.data("browser") + ":</b> " + $.browser + "<br />")
      ck.insertHtml("<b>" + form.data("version") + "</b> " + $.browser.version + "<br />")
      ck.insertHtml("<b>" + form.data("os") + "</b> os<br />")
    
    @browser_and_os_inserted = false
    $("#task_task_type").change ->
      insert_browser_and_os() if this.value == "bug" && !@browser_and_os_inserted
