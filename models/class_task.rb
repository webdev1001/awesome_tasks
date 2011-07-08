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
  
  def self.add(d)
    raise _("No project-ID was given.") if d.data[:project_id].to_i <= 0
    
    begin
      task = d.ob.get(:Project, d.data[:project_id])
    rescue Knj::Errors::NotFound
      raise sprintf(_("A project with the given project-ID could not be found: '%s'."), d.data[:project_id])
    end
  end
  
  def html
    return "<a href=\"?show=task_show&amp;task_id=#{id}\">#{name.html}</a>"
  end
  
  def timelogs(args = {})
    return _ob.list(:Timelog, {"task" => self}.merge(args))
  end
  
  def comments(args = {})
    return _ob.list(:Comment, {"object_lookup" => self}.merge(args))
  end
end