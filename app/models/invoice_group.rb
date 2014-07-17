class InvoiceGroup < ActiveRecord::Base
  has_many :invoices, :dependent => :restrict_with_error
  validates_presence_of :name
end
