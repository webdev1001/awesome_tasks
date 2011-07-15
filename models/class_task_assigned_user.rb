class Knjtasks::Task_assigned_user < Knj::Datarow
  has_one [
    {:classname => :User, :required => true},
    {:classname => :Task, :required => true}
  ]
  
  def self.list(d)
    sql = "SELECT #{table}.* FROM #{table}"
    
    if d.args["orderby"] == "project_task_names"
      orderby = "project_task_names"
      d.args.delete("orderby")
      
      sql += "
        LEFT JOIN Task ON
          Task.id = #{table}.task_id
        
        LEFT JOIN Project ON
          Project.id = Task.project_id
      "
    end
    
    sql += " WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: %s."), key)
    end
    
    sql += ret[:sql_where]
    
    if orderby == "task_name"
      sql += " ORDER BY Project.name, Task.name"
    else
      sql += ret[:sql_order]
    end
    
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(table, sql)
  end
  
  def self.add(d)
    link = d.ob.get_by(:Task_assigned_user, {
      "task_id" => d.data[:task_id],
      "user_id" => d.data[:user_id]
    })
    raise _("That user is already assigned to that task.") if link
  end
  
  def add_after(d)
    task.send_notify_assigned(user, _site.user)
  end
end