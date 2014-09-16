$ ->
  # Change autonumeric fields to the right internationalized format.
  $("input").each ->
    input = $(this)

    if input.data("autonumeric")
      input.attr("type", "text")
      input.autoNumeric("init", {
        aDec: locale_strings.number_format_separator
        aSep: locale_strings.number_format_delimiter
      })
