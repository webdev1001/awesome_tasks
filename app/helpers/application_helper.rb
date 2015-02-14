module ApplicationHelper
  include SimpleFormRansackHelper
  include RailsImager::ImagesHelper
  include AgentHelpers::DetectorHelper
  include LightMobile::TabsHelper

  def knjrbfw_opts(query, args = {})
    list = {}
    list[""] = _("Choose:") if args[:choose]
    list[""] = _("All") if args[:all]

    query.each do |model|
      list[model.id] = model.name
    end

    return list
  end

  def time_as_string(time)
    return "00:00:00" unless time
    return time.strftime("%H:%M:%S")
  end

  def format_number(number, args = {})
    return number_to_currency(number, {unit: ""}.merge(args))
  end

  def link_to_model(model)
    method_name = "link_to_#{StringCases.camel_to_snake(model.class.name)}"
    __send__(method_name, model)
  end

  def form_boolean_collection
    {
      _("All") => nil,
      _("True") => 1,
      _("False") => 0
    }
  end
end
