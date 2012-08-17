class Knjtasks::User_project_link < Knj::Datarow
  has_one [
    :User,
    :Project
  ]
  
  def self.list(d)
    if d.args["orderby"] == "user_name"
      join_users = true
      orderby = "User.name"
      d.args.delete("orderby")
    end
    
    sql = "SELECT User_project_link.* FROM User_project_link"
    
    if join_users
      sql += "
        LEFT JOIN User ON
          User.id = User_project_link.user_id
      "
    end
    
    sql += " WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      raise sprintf(_("Invalid key: '%s'."), key)
    end
    
    sql += ret[:sql_where]
    
    sql += " GROUP BY User_project_link.id"
    
    if orderby
      sql += " ORDER BY #{orderby}"
    else
      sql += ret[:sql_order]
    end
    
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:User_project_link, sql)
  end
  
  def self.add(d)
    user = d.ob.get(:User, d.data[:user_id])
    project = d.ob.get(:Project, d.data[:project_id])
    
    exists = d.ob.get_by(:User_project_link, {
      "user" => user,
      "project" => project
    })
    raise Errno::EEXIST, _("That user is already assigned to that project.") if exists
  end
  
  def add_after(d)
    if self.user.has_email?
      subj = sprintf(_hb.gettext.gettext("Assigned to project: %s", self.user.locale), self.project.name)
      
      html = ""
      html += sprintf(_hb.gettext.gettext("You have been assigned to the project: '%s'.", self.user.locale), self.project.name)
      
      _hb.mail(:to => self.user[:email], :subject => subj, :html => html)
    end
  end
end