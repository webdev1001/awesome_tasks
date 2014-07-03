@roles_reload = null

$ ->
  return if $("body.controller_users").length <= 0
  
  if $("body.action_index").length > 0
    $("#user_name").focus()
    modal_on_opened -> $("#user_name").focus()
  
  if $("body.action_new").length > 0 || $("body.action_edit").length > 0
    form = $("form.new_user, form.edit_user")
    user_id = form.data("user-id")
    $("#user_username").focus()
    
    form.submit ->
      if $("#user_password").val().length > 0
        $("#user_encrypted_password").val($.md5($("#user_password").val()))
      else
        $("#user_encrypted_password").val("")
      
      $("#user_password").val("")
      return true
    
    $(".add_rank_button").click ->
      modal({title: form.data("add-rank-text"), url: form.data("new-role-path")})
    
    window.roles_reload = ->
      $.ajax({type: "GET", url: form.data("roles-user-path"), async: true, cache: false, complete: (data) ->
        $("#divpermissions").slideUp "fast", ->
          $("#divpermissions").html(data.responseText)
          $("#divpermissions").slideDown("fast")
      })
    
    window.role_remove = (link_id) ->
      $.ajax({type: "DELETE", url: "/user_roles/" + link_id, async: true, cache: false, complete: (data) ->
        alert(data.responseText) if $.trim(data.responseText).length > 0
        @roles_reload()
      })
    
    window.role_add = (rank_id) ->
      modal_close()
      
      $.ajax({type: "GET", url: form.data("new-user-role-path"), async: true, cache: false, complete: (data) ->
        alert(data.responseText) if $.trim(data.responseText).length > 0
        @roles_reload()
      })
  
  if $("body.action_show").length > 0
    $(".tasks-filter-button").click (e) ->
      e.preventDefault()
      $(".tasks-filter-button-container").slideUp "fast", ->
        $(".tasks-filter").slideDown "fast", ->
          $("#task_name").focus()
    
    $(".tasks-hide-filter-button").click (e) ->
      e.preventDefault()
      $(".tasks-filter").slideUp "fast", ->
        $(".tasks-filter-button-container").slideDown("fast")
  
@users_index_init = ->
  $("#form_users").bind "ajax:complete", (env, data, status) ->
    $("#divresults").slideUp "fast", ->
      $("#divresults").html(data.responseText)
      $("#divresults").slideDown("fast")
