class Knjtasks::Comment < Knj::Datarow
  has_one [
    {:class => :User, :required => true}
  ]
  
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
    d.data[:user_id ] = _site.user.id if !d.data[:user_id] and _site.user
    d.data[:date_saved] = Time.new if !d.data[:date_saved]
    
    raise "No 'object_class' was given." if !d.data[:object_class]
    raise "No 'object_id' was given." if !d.data[:object_id]
    
    obj = d.ob.get(d.data[:object_class], d.data[:object_id])
    user = d.ob.get(:User, d.data[:user_id])
  end
  
  def object
    return ob.get_try(self, :object_id, self[:object_class])
  end
  
  def add_after(d)
    self.object.send_notify_new_comment(self) if self.object.class.name == "Knjtasks::Task"
  end
end