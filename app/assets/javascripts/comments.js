function comment_delete(comment_id){
  $.ajax({type: "GET", url: "clean.rhtml?show=comment_edit&choice=dodelete&comment_id=" + comment_id, cache: false, async: true, complete: function(data){
    if (data.responseText.length > 0){
      alert(data.responseText);
    }
    
    events.call("do_comments_update");
  }});
}

function comment_edit(comment_id){
  modal({title: locale_strings["comment_edit_title"], url: "clean.rhtml?show=comment_edit&comment_id=" + comment_id});
}
