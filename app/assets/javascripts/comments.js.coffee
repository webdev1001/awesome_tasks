window.comment_delete = (comment_id) ->
  $.ajax type: "DELETE", url: "/comments/" + comment_id, cache: false, async: true, complete: (data) ->
    alert(data.responseText) if $.trim(data.responseText).length > 0
    events.call 'do_comments_update'

window.comment_edit = (comment_id) ->
  modal({"title": locale_strings["comment_edit_title"], "url": "/comments/" + comment_id + "/edit"})

window.comment_new = (resource_type, resource_id) ->
  modal({"title": locale_strings["comment_new_title"], "url": "/comments/new?comment[resource_type]=" + resource_type + "&comment[resource_id]=" + resource_id})
  events.call 'on_comments_new'
