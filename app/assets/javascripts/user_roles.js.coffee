$ ->
  $("body").on "ajax:complete", "form.new_user_role, form.edit_user_role", (env, data) ->
    if $.trim(data.responseText).length > 0
      alert(data.responseText)
    else
      roles_reload()
      modal_close()

  $("body").on "ajax:complete", ".destroy_user_role", (env, data) ->
    roles_reload()
