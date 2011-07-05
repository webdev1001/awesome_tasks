class Knjtasks
  def initialize(args = {})
    require "rubygems"
    require "knjappserver"
    require "knjrbfw"
    require "knj/autoload"
    require "knj/objects"
    
    @args = args
    
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
      :db => @args[:db],
      :smtp_args => @args[:smtp_args],
      :httpsession_db_args => @args[:db_args]
    )
    @knjappserver.update_db
  end
  
  def join
    #@knjappserver.join
  end
  
  def start
    @knjappserver.start
  end
  
  def load_request
    
  end
end