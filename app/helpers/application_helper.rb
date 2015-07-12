module ApplicationHelper
  include SimpleFormRansackHelper
  include RailsImager::ImagesHelper
  include AgentHelpers::DetectorHelper
  include LightMobile::TabsHelper
  include AwesomeTranslations::ApplicationHelper

  def knjrbfw_opts(query, args = {})
    list = {}
    list[""] = t("choose") if args[:choose]
    list[""] = t("all") if args[:all]

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
      t("all") => nil,
      t("true") => 1,
      t("false") => 0
    }
  end

  def simple_format_default_args(text)
    simple_format text, nil, wrapper_tag: :div
  end

  def available_locales
    {
      "da" => helper_t(".danish"),
      "en" => helper_t(".english")
    }
  end
end
