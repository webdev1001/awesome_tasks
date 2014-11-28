# Change autonumeric fields to the right internationalized format.
$ ->
  inputs = $("input[data-autonumeric=true]")
  inputs.attr("type", "text")
  inputs.autoNumeric("init", {
    aDec: locale_strings.number_format_separator
    aSep: locale_strings.number_format_delimiter
  })
