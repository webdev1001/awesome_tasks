class DesignBox
  def self.boxt(title, width = "100%")
    width = "#{width}px" if width.is_a?(Fixnum) or width.is_a?(Integer)

    html = ""
    html += "<table class=\"box\" style=\"width: #{width};\" cellspacing=\"0\" cellpadding=\"0\">"
    html += "<tr><td class=\"box_header_spacer\">&nbsp;</td><td class=\"box_header\">#{title}</td></tr>"
    html += "<tr><td colspan=\"2\" class=\"box_content\">"
    return html.html_safe
  end

  def self.boxb
    return "</td></tr></table>".html_safe
  end
end
