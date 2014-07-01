module ViewRenderer
  def render_to_string(options)
    controller = ApplicationController.new
    
    if Rails.env.development?
      controller.asset_host = "http://#{hostname}:3000"
    else
      controller.asset_host = "http://#{hostname}"
    end
    
    av = ActionView::Base.new ActionController::Base.view_paths, {}, controller
    av.extend ApplicationController._helpers
    av.render options
  end

  def render_pdf_to_string(template = self.class.name.downcase)
    model_name = self.class.name.downcase
    
    av = ActionView::Base.new ActionController::Base.view_paths
    av.extend ApplicationController._helpers
    av.render :template => "pdfs/#{template}", :locals => {model_name.to_sym => self}
  end
end
