$ ->
  return if $(".controller_timelogs").length <= 0
  
  $("#form_filter").submit ->
    $("input[name=users]").val(select_values({sel: $("#seluser"), selected: true, expl: ";"}))
    $("input[name=projects]").val(select_values({sel: $("#selproject"), selected: true, expl: ";"}))
    $("#seluser").val(false)
    return true
  
  $(".mark_timelogs_as_invoiced").click (e)->
    e.preventDefault()
    button = $(this)
    return unless confirm(button.data("confirm-msg"))
    
    tlog_ids = []
    $("input[type=hidden]", $("#table_customer_message")).each ->
      id = $(this).attr("name").substring(9)
      tlog_ids.push(id)
    
    $.ajax({
      type: "POST",
      url: button.data("url"),
      data: {tlog_ids: tlog_ids.join(";")},
      async: false,
      cache: false,
      complete: (data)->
        if $.trim(data.responseText).length > 0
          alert(data.responseText)
        else
          alert(button.data("success-msg"))
    })
  
  $("#texdatefrom").focus()
