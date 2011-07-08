class Knjtasks::Comment < Knj::Datarow
  def self.list(d)
    sql = "SELECT * FROM Comment WHERE 1=1"
    
    ret = list_helper(d)
    d.args.each do |key, val|
      case key
        when "object_lookup"
          sql += " AND object_class = '#{val.table}' AND object_id = '#{d.db.esc(val.id)}'"
        else
          raise sprintf(_("Invalid key: %s."), key)
      end
    end
    
    sql += ret[:sql_where]
    sql += ret[:sql_order]
    sql += ret[:sql_limit]
    
    return d.ob.list_bysql(:Comment, sql)
  end
  
  def self.add(d)
    if !d.data[:user_id] and _site.user
      d.data[:user_id ] = _site.user.id
    end
    
    obj = d.ob.get(d.data[:object_class], d.data[:object_id])
    user = d.ob.get(:User, d.data[:user_id])
  end
end