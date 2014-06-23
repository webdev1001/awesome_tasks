class Customer < ActiveRecord::Base
  has_many :projects
  
  validates :email, :email => true
end
