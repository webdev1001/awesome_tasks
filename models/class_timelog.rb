class Knjtasks::Timelog < Knj::Datarow
  has_one [
    :Task,
    :User
  ]
  
  def self.list(d)
    sql = "SELECT"
    
    join_tasks = true if d.args["project_id"]
    
    if d.args[:count]
      count = true
      d.args.delete(:count)
      sql += "
        SUM(TIME_TO_SEC(Timelog.time)) AS sum_time,
        SUM(TIME_TO_SEC(Timelog.time_transport)) AS sum_time_transport,
        SUM(Timelog.transport_length) AS sum_transport_length
      "
    else
      sql += " Timelog.*"
    end
    
    sql += " FROM Timelog"
    
    if join_tasks
      sql += "
        LEFT JOIN Task ON
          Task.id = Timelog.task_id
      "
    end
    
    sql += " WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      case key
        when "project_id"
          if val.is_a?(Array)
            sql += " AND Task.project_id IN (" + Knj::ArrayExt.join(:arr => val, :sep => ",", :surr => "'", :callback => proc{|data| d.db.esc(data)}) + ")"
          else
            sql += " AND Task.project_id = '#{d.db.esc(val)}'"
          end
        else
          raise sprintf(_("Invalid key: %s."), key)
      end
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
  
  def html(args = {})
    if args[:key] == :id_localized
      name = Knj::Locales.number_out(id, 0)
    elsif args[:key]
      name = self[args[:key]].html
    else
      name = sprintf(_("Timelog %s"), Knj::Locales.number_out(id, 0))
    end
    
    return "<a href=\"javascript: timelog_edit('#{id}');\">#{name}</a>"
  end
  
  def comment_html
    return Php4r.nl2br(Knj::Web.html(self[:comment]))
  end
end