class Knjtasks::Customer < Knj::Datarow
  has_many [
    {:class => :Project, :col => :customer_id, :depends => true}
  ]
  
  def self.add(d)
    d.data[:date_added] = Time.new if !d.data[:date_added]
  end
  
  def html
    return "<a href=\"?show=customer_show&amp;customer_id=#{id}\">#{name.html}</a>"
  end
end