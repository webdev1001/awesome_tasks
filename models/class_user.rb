class Knjtasks::User < Knj::Datarow
  has_many [
    {:classname => :Task, :colname => :user_id, :depends => true},
    {:classname => :Task_assigned_user, :colname => :user_id, :methodname => :assigned_to_tasks, :depends => true}
  ]
  
  def self.list(d)
    sql = "SELECT * FROM User WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:User, sql)
  end
  
  def delete
    
  end
  
  def name
    if self[:name].to_s.length > 0
      return self[:name]
    elsif self[:username].to_s.length > 0
      return self[:username]
    end
    
    raise "Could not figure out a name?"
  end
  
  def html
    return "<a href=\"?show=user_show&amp;user_id=#{id}\">#{name.html}</a>"
  end
  
  def name
    return self[:username].to_s
  end
end