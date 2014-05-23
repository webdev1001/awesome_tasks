function comment_delete(comment_id){
  $.ajax({type: "DELETE", url: "/comments/" + comment_id, cache: false, async: true, complete: function(data){
    if ($.trim(data.responseText).length > 0){
      alert(data.responseText);
    }
    
    events.call("do_comments_update")
  }})
}

function comment_edit(comment_id){
  modal({"title": locale_strings["comment_edit_title"], "url": "/comments/" + comment_id + "/edit"})
}

function comment_new(resource_type, resource_id){
  modal({"title": locale_strings["comment_new_title"], "url": "/comments/new?comment[resource_type]=" + resource_type + "&comment[resource_id]=" + resource_id})
}
