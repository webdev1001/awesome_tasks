class Knjtasks::User < Knj::Datarow
  has_many [
    {:class => :Task, :col => :user_id, :depends => true},
    {:class => :Task_assigned_user, :col => :user_id, :method => :assigned_to_tasks, :depends => true},
    {:class => :User_rank_link, :col => :user_id, :method => :ranks, :depends => true}
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
    raise _("Cannot delete user because that user has created tasks.") if ob.get_by(:Task, {"user" => self})
  end
  
  def name
    if self[:name].to_s.length > 0
      return self[:name]
    elsif self[:username].to_s.length > 0
      return self[:username]
    end
    
    raise "Could not figure out a name?"
  end
  
  def locale
    return self[:locale] if self[:locale].to_s.length > 0
    return "en_GB"
  end
  
  def has_rank?(rank_str)
    rank = @ob.get_by(:User_rank, {
      "id_str" => rank_str
    })
    return false if !rank
    
    rank_link = @ob.get_by(:User_rank_link, {
      "user" => self,
      "rank" => rank
    })
    return false if !rank_link
    
    return true
  end
  
  def html
    return "<a href=\"?show=user_show&amp;user_id=#{id}\">#{name.html}</a>"
  end
end