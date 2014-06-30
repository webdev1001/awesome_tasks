class Customer < ActiveRecord::Base
  has_many :projects, :dependent => :restrict_with_error
  has_many :invoices, :dependent => :restrict_with_error
  has_many :credit_invoices, :dependent => :restrict_with_error, :foreign_key => :creditor_id, :class_name => "Invoice"
  
  validates :email, :email => true
end
