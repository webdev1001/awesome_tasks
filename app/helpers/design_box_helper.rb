module DesignBoxHelper
  def design_box(title, width = "100%")
    width = "#{width}px" if width.is_a?(Fixnum) or width.is_a?(Integer)

    content_tag(:table, nil, class: "box", style: "width: #{width}", cellspacing: 0, cellpadding: 0) do
      content_tag(:tr) do
        content_tag(:td, "&nbsp".html_safe, class: "box_header_spacer") +
        content_tag(:td, title, class: "box_header")
      end +

      content_tag(:tr) do
        content_tag(:td, nil, class: "box_content", colspan: 2) do
          yield
        end
      end
    end
  end
end
