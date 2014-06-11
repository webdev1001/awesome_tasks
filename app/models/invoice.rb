class Invoice < ActiveRecord::Base
  belongs_to :customer
  belongs_to :user
  
  has_many :invoice_lines
end
