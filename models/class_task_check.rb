class Knjtasks::Task_check < Knj::Datarow
  has_one [
    {:class => :User, :col => :added_user_id, :method => :user_added, :required => true},
    :Task
  ]
  
  def self.list(d)
    sql = "SELECT * FROM #{table} WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:Task_check, sql)
  end
  
  def self.add(d)
    d.data[:added_user_id] = _site.user.id if !d.data[:added_user_id] and _site.user
    d.data[:date_added] = Time.now if !d.data[:date_added]
  end
end