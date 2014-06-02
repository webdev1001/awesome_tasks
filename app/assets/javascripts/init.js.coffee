$ ->
  window.events = new Events()
  
  modal_setup({
    url: js_settings["knjjs_url"],
    css: {
      "border": "3px solid #4e4e4e",
      "background-color": "#f6f6f6",
      "padding": "10px",
      "padding-top": "0px",
      "padding-bottom": "14px",
      "width": "700px",
      "height": "700px",
      "overflow": "auto"
    },
    css_header: {
      "font-size": "16px",
      "font-weight": "bold",
      "padding-bottom": "7px",
      "padding-top": "5px",
      "color": "#000000"
    }
  })
  
  $("select[name=bottom_locale]").change ->
    locales_set($(this).val())
