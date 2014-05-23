@locales_set = (locale)->
  $.ajax({url: "/locales/set", type: "POST", "/locales/set", data: {"locale": locale}, complete: (data)->
    if $.trim(data.responseText).length > 0
      alert(data.responseText)
    
    location.reload()
  })
