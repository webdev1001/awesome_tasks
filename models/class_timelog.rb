class Knjtasks::Timelog < Knj::Datarow
  def self.list(d)
    sql = "SELECT * FROM Timelog WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:Timelog, sql)
  end
  
  def self.add(d)
    if !d.data[:user_id] and _site.user
      d.data[:user_id] = _site.user.id
    end
    
    task = d.ob.get(:Task, d.data[:task_id])
  end
  
  def html
    return "?show=timelog_edit&amp;timelog_id=#{id}\">#{sprintf(_("Timelog %s"), id)}</a>"
  end
  
  def task
    return ob.get_try(self, :task_id, :Task)
  end
  
  def user
    return ob.get_try(self, :user_id, :User)
  end
  
  def user_html
    return user.html if user
    return "[#{_("no user")}]"
  end
end