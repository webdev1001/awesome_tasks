$ ->
  return unless $("body.controller_profile").length > 0
  
  $("form.edit_user").submit ->
    $("input[name=passwd_md5]").val($.md5($("#texpasswd").val()))
    $("#texpasswd").val("")
    return true
