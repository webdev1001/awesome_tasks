class Knjtasks::User < Knj::Datarow
  has_many [
    {:class => :Task, :col => :user_id, :depends => true},
    {:class => :Task_assigned_user, :col => :user_id, :method => :assigned_to_tasks, :depends => true},
    {:class => :User_rank_link, :col => :user_id, :method => :ranks, :depends => true},
    {:class => :User_project_link, :col => :user_id, :method => :projects, :depends => true}
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
  
  def has_email?
    return Knj::Strings.is_email?(self[:email])
  end
  
  def html
    name_str = self[:name]
    if name_str.to_s.strip.length <= 0
      name_str = self[:username]
    end
    
    if name_str.to_s.strip.length <= 0
      name_str = "[#{_("no name")}]"
    end
    
    return "<a href=\"?show=user_show&amp;user_id=#{id}\">#{name_str.html}</a>"
  end
  
  def has_view_access?(user)
    return false if !user
    return true if user.has_rank?("admin")
    
    res = _db.query("
      SELECT
        *
      
      FROM
        User_project_link AS user_link,
        User_project_link AS my_link
      
      WHERE
        user_link.user_id = '#{_db.esc(user.id)}' AND
        my_link.user_id = '#{_db.esc(self.id)}' AND
        user_link.project_id = my_link.project_id
      
      LIMIT
        1
    ").fetch
    return true if res
    
    return false
  end
end