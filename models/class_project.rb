class Knjtasks::Project < Knj::Datarow
  def self.list(d)
    sql = "SELECT * FROM Project WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:Project, sql)
  end
  
  def self.add(d)
    raise _("Invalid name given.") if d.data[:name].to_s.strip.length <= 0
    
    if !d.data[:added_user_id] and _site.user
      d.data[:added_user_id] = _site.user.id
    end
    
    if !d.data[:added_date]
      d.data[:added_date] = Time.new
    end
  end
  
  def html
    return "<a href=\"?show=project_show&amp;project_id=#{id}\">#{name.html}</a>"
  end
  
  def added_user
    return _ob.get_try(self, :added_user_id, :User)
  end
end