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
  
  def html
    return "?show=timelog_edit&amp;timelog_id=#{id}\">#{sprintf(_("Timelog %s"), id)}</a>"
  end
end