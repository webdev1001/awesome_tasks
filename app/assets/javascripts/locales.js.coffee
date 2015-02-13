@locales_set = (locale)->
  $.ajax({url: "/locales", type: "POST", data: {"locale": {"locale": locale}}, complete: (data)->
    if $.trim(data.responseText).length > 0
      alert(data.responseText)

    location.reload()
  })
