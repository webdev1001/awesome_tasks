module ApplicationHelper
  include SimpleFormRansackHelper
  
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
end