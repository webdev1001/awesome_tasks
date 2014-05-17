class Customer < ActiveRecord::Base
  has_many :projects
  
  def self.add(d)
    d.data[:date_added] = Time.new if !d.data[:date_added]
  end
  
  def html
    return "<a href=\"?show=customer_show&amp;customer_id=#{id}\">#{name.html}</a>"
  end
end
