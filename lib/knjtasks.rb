class Knjtasks
  attr_reader :knjappserver, :ob, :db, :args
  
  def initialize(args = {})
    @args = args
    @db = @args[:db]
    
    require "rubygems"
    require "#{@args[:knjappserver_path]}knjappserver"
    require "#{@args[:knjrbfw_path]}knjrbfw"
    
    require "#{@args[:knjrbfw_path]}knj/autoload"
    require "#{@args[:knjrbfw_path]}knj/objects"
    
    
    check_args = [:db, :knjjs_url, :port, :email_admin, :email_robot, :db_args, :title]
    check_args.each do |key|
      raise "No '#{key}' given in arguments." if !@args.has_key?(key)
    end
    
    if @args[:knjdbrevision_path]
      require "#{@args[:knjdbrevision_path]}/knjdbrevision.rb"
    else
      require "knjdbrevision"
    end
    
    require "#{File.dirname(__FILE__)}/../files/database_schema.rb"
    dbrev = Knjdbrevision.new
    dbrev.init_db($schema, @db)
    
    @ob = Knj::Objects.new(
      :datarow => true,
      :db => @db,
      :class_path => "#{File.dirname(__FILE__)}/../models",
      :module => Knjtasks,
      :require_all => true
    )
    
    @ob.events.connect(:no_html) do |event, classname|
      class_trans = @class_translations[classname]
      class_trans = classname.to_s.downcase if !class_trans
      
      msg = "[#{sprintf(_("no %s"), class_trans)}]"
      msg
    end
    
    @ob.events.connect(:no_date) do |date|
      str = "[#{_("no date")}]"
      str
    end
    
    @knjappserver = Knjappserver.new(
      :debug => @args[:debug],
      :autorestart => false,
      :autoload => false,
      :verbose => false,
      :title => @args[:title],
      :port => @args[:port],
      :host => @args[:host],
      :default_page => "index.rhtml",
      :doc_root => "#{File.dirname(__FILE__)}/../www",
      :hostname => false,
      :error_report_emails => [@args[:email_admin]],
      :error_report_from => @args[:email_robot],
      :locales_root => "#{File.dirname(__FILE__)}/../locales",
      :locales_gettext_funcs => true,
      :locale_default => "da_DK",
      :knjrbfw_path => @args[:knjrbfw_path],
      :knjappserver_path => @args[:knjappserver_path],
      :knjdbrevision_path => @args[:knjdbrevision_path],
      :db => @db,
      :smtp_args => @args[:smtp_args],
      :httpsession_db_args => @args[:db_args]
    )
    @knjappserver.define_magic_var(:_site, self)
    @knjappserver.define_magic_var(:_ob, @ob)
    
    if @args.has_key?(:mail_args)
      require "#{File.dirname(__FILE__)}/../threads/thread_mail_task_comments.rb"
      @thread_mail_task_comments = Knjtasks::Thread_mail_task_comments.new(
        :knjtasks => self,
        :ob => @ob,
        :appsrv => @knjappserver,
        :args => @args
      )
      
      if @args[:debug]
        time = 5
      else
        time = 60
      end
      
      @knjappserver.timeout(:time => time) do
        @thread_mail_task_comments.run
      end
    end
    
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
    Knj::Php.header("Content-Type: text/html; charset=utf-8")
    
    #This will make the new Ruby-tasks-system compatible with mails sent from the old PHP-tasks-system.
    _get["show"] = "task_show" if _get["show"] == "tasks_show"
    _get["show"] = "user_login" if _get["show"] == "users_login"
    
    if _get.has_key?("l")
      _session[:locale] = _get["l"]
      _site.user[:locale] = _get["l"] if _site.user
      _kas.redirect(_meta["REQUEST_URI"].gsub(/&l=([A-z_]+)/, ""))
    end
  end
  
  def header(title)
    return "<h1>#{title}</h1>"
  end
  
  def boxt(title, width = "100%")
    width = "#{width}px" if width.is_a?(Fixnum) or width.is_a?(Integer)
    
    html = ""
    html += "<table class=\"box\" style=\"width: #{width};\" cellspacing=\"0\" cellpadding=\"0\">"
    html += "<tr><td class=\"box_header_spacer\">&nbsp;</td><td class=\"box_header\">#{title}</td></tr>"
    html += "<tr><td colspan=\"2\" class=\"box_content\">"
    return html
  end
  
  def boxb
    return "</td></tr></table>"
  end
  
  def user
    begin
      if _session[:user_id].to_i > 0
        user = @ob.get(:User, _session[:user_id])
        if !user.active?
          _session.delete(:user_id)
          return false
        end
        
        return user
      end
    rescue
      return false
    end
    
    return false
  end
  
  def has_rank?(rank_str)
    return false if !self.user
    return self.user.has_rank?(rank_str)
  end
end