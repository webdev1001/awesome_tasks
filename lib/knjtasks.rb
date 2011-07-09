class Knjtasks
  attr_reader :knjappserver, :ob, :db, :args
  
  def initialize(args = {})
    require "rubygems"
    require "knjappserver"
    require "knjrbfw"
    require "knj/autoload"
    require "knj/objects"
    
    @args = args
    @db = @args[:db]
    
    @ob = Knj::Objects.new(
      :datarow => true,
      :db => @db,
      :class_path => "#{File.dirname(__FILE__)}/../models",
      :module => Knjtasks
    )
    @ob.events.connect(:no_html) do |event, classname|
      class_trans = @class_translations[classname]
      class_trans = classname.to_s.downcase if !class_trans
      
      msg = "[#{sprintf(_("no %s"), class_trans)}]"
      msg
    end
    
    @erbhandler = Knjappserver::ERBHandler.new
    @knjappserver = Knjappserver.new(
      :debug => false,
      :autorestart => false,
      :autoload => false,
      :verbose => false,
      :title => "knjTasks",
      :port => @args[:port],
      :host => @args[:host],
      :default_page => "index.rhtml",
      :doc_root => "#{File.dirname(__FILE__)}/../www",
      :hostname => false,
      :default_filetype => "text/html",
      :engine_knjengine => true,
      :error_report_emails => [@args[:email_admin]],
      :error_report_from => @args[:email_robot],
      :locales_root => "#{File.dirname(__FILE__)}/../locales",
      :locales_gettext_funcs => true,
      :locale_default => "da_DK",
      :max_requests_working => 5,
      :filetypes => {
          :jpg => "image/jpeg",
          :gif => "image/gif",
          :png => "image/png",
          :html => "text/html",
          :htm => "text/html",
          :rhtml => "text/html",
          :css => "text/css",
          :xml => "text/xml",
          :js => "text/javascript"
      },
      :handlers => [
          :file_ext => "rhtml",
          :callback => @erbhandler.method(:erb_handler)
      ],
      :db => @db,
      :smtp_args => @args[:smtp_args],
      :httpsession_db_args => @args[:db_args]
    )
    @knjappserver.update_db
    @knjappserver.define_magic_var(:_site, self)
    @knjappserver.define_magic_var(:_ob, @ob)
    
    @class_translations = {
      :User => _("user"),
      :Project => _("project"),
      :Task => _("task")
    }
  end
  
  def join
    @knjappserver.join
  end
  
  def start
    @knjappserver.start
  end
  
  def load_request
    
  end
  
  def header(title)
    return "<h1>#{title}</h1>"
  end
  
  def boxt(title, width = "100%")
    html = ""
    html += "<table class=\"box\" style=\"width: #{width};\">"
    html += "<tr><td class=\"box_header\">#{title}</td></tr>"
    html += "<tr><td class=\"box_content\">"
    return html
  end
  
  def boxb
    return "</td></tr></table>"
  end
  
  def user
    begin
      return @ob.get(:User, _session[:user_id]) if _session[:user_id].to_i > 0
    rescue
      return false
    end
    
    return false
  end
end