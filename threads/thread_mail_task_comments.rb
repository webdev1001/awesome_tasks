#This class checks the mail-account for mails and imports them as comments.
class Knjtasks::Thread_mail_task_comments
  def initialize(args = {})
    @args = args
    
    require "rubygems"
    require "mail"
    
    if !@args[:args][:mail_args][:port]
      @args[:args][:mail_args][:port] = 143 if @args[:args][:mail_args][:type] == "imap"
      @args[:args][:mail_args][:port] = 100 if @args[:args][:mail_args][:type] == "pop3"
    end
  end
  
  def run
    STDOUT.print "Checking for mails.\n" if @args[:appsrv].debug
    conn = Net::IMAP.new(@args[:args][:mail_args][:host], @args[:args][:mail_args][:port].to_i, @args[:args][:mail_args][:ssl])
    
    if @args[:args][:mail_args][:user] and @args[:args][:mail_args][:pass]
      conn.login(@args[:args][:mail_args][:user], @args[:args][:mail_args][:pass])
    end
    
    conn.select("INBOX")
    emails = conn.search(["ALL"])
    emails.each do |msg_id|
      error = nil
      from = nil
      html = nil
      
      begin
        msg = conn.fetch(msg_id, "(ENVELOPE RFC822)")
        mail = Mail.new(msg[0].attr["RFC822"])
        
        env = msg[0].attr["ENVELOPE"]
        from = "#{env.from.first.mailbox}@#{env.from.first.host}"
        env_msg_id = env.message_id
        
        if _ob.static(:Email_check, :checked_id?, env_msg_id)
          next
        else
          _db.insert(:Email_check, {:email_id_str => env_msg_id})
        end
        
        user = @args[:ob].get_by(:User, {"email" => from})
        raise "Could not find a user in this task-system with that email: '#{from}'." if !user
        
        subj_match = mail.subject.to_s.match(/^([A-z]{1,3}):\s+(\S+)\s+#(\d+):\s+/)
        raise "Could not figure out the task-ID from the email." if !subj_match
        task_id = subj_match[3]
        
        begin
          task = @args[:ob].get(:Task, task_id)
        rescue
          raise "Could not find a task in this task-system with that task-ID: '#{task_id}'."
        end
        
        parts = {}
        mail.parts.each do |part|
          if part.content_type.match(/^text\/plain/)
            parts[:plain] = part.body.to_s
          elsif part.content_type.match(/^text\/html/) and match = part.body.match(/<body.*>([\s\S]+)<\/body>/)
            parts[:html] = match[1]
          end
        end
        
        if parts[:html]
          html = parts[:html]
          html.gsub!(/<blockquote([\s\S]+?)>([\s\S]+?)<\/blockquote>/i, "")
          html.gsub!(/on\s+\d+.+?\s+wrote:/i, "")
          html.gsub!(/<pre.+?class="moz-signature".*?>([\s\S]*?)<\/pre>/i, "")
          html = Knj::Strings.strip(html, {
            :strips => [" ", "\n", "\r", "<br>", "<br />", "<br/>"]
          })
        elsif parts[:plain]
          html = parts[:plain]
          html.gsub!(/on\s+\d+.+?\s+wrote:/i, "")
          html.gsub!(/^>(.*?)\n/, "")
          html.gsub!(/\n-- \n[\s\S]++/, "")
          html = Knj::Strings.strip(html, {
            :strips => ["\n", "\r", "<br>", "<br />", "<br/>"]
          })
          html.gsub!(/\n/, "<br>")
        end
        
        raise "Could not read any content in the email." if !html
        
        comment = @args[:ob].add(:Comment, {
          :object_class => :Task,
          :object_id => task.id,
          :comment => html,
          :user_id => user.id
        })
        
        conn.store(msg_id, "+FLAGS", ["DELETED"])
        conn.expunge
      rescue => e
        if !from
          STDOUT.print "Could not respond to task-email."
          STDOUT.puts e.inspect
          STDOUT.puts e.backtrace
        else
          @args[:appsrv].mail(
            :to => from,
            :subject => "Your email to the task-system.",
            :text => "Could not parse your email:\n\n#{e.inspect}\n#{e.backtrace.join("\n")}"
          )
        end
      end
    end
    
    conn.logout
    conn.disconnect
  end
end