class Knjtasks::Customer < Knj::Datarow
  has_many [
    [:Project, :customer_id]
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
    
    return d.ob.list_bysql(:Customer, sql)
  end
  
  def self.add(d)
    d.data[:date_added] = Time.new if !d.data[:date_added]
  end
  
  def name
    return self[:name]
  end
  
  def html
    return "<a href=\"?show=customer_show&amp;customer_id=#{id}\">#{name.html}</a>"
  end
end