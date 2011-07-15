class Knjtasks::Timelog < Knj::Datarow
  has_one [
    :Task,
    :User
  ]
  
  def self.list(d)
    sql = "SELECT"
    
    if d.args[:count]
      count = true
      d.args.delete(:count)
      sql += "
        SUM(TIME_TO_SEC(Timelog.time)) AS sum_time,
        SUM(TIME_TO_SEC(Timelog.time_transport)) AS sum_time_transport,
        SUM(Timelog.transport_length) AS sum_transport_length
      "
    else
      sql += "*"
    end
    
    sql += " FROM Timelog WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    
    if count
      return d.db.query(sql).fetch
    end
    
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:Timelog, sql)
  end
  
  def self.add(d)
    d.data[:user_id] = _site.user.id if !d.data[:user_id] and _site.user
    raise _("No comment has been written.") if d.data[:comment].to_s.length <= 0
    task = d.ob.get(:Task, d.data[:task_id])
  end
  
  def html
    return "<a href=\"?show=timelog_edit&amp;timelog_id=#{id}\">#{sprintf(_("Timelog %s"), id)}</a>"
  end
end