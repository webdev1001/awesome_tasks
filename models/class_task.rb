class Knjtasks::Task < Knj::Datarow
  def self.list(d)
    sql = "SELECT * FROM Task WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:Task, sql)
  end
  
  def html
    return "<a href=\"?show=task_show&amp;task_id=#{id}\">#{name.html}</a>"
  end
end