class Knjtasks::Project < Knj::Datarow
  has_one [
    {:classname => :User, :colname => :added_user_id, :methodname => :added_user, :required => true}
  ]
  has_many [[:Task, :project_id]]
  
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
    
    d.data[:added_user_id] = _site.user.id if !d.data[:added_user_id] and _site.user
    d.data[:added_date] = Time.new if !d.data[:added_date]
  end
  
  def html
    return "<a href=\"?show=project_show&amp;project_id=#{id}\">#{name.html}</a>"
  end
end