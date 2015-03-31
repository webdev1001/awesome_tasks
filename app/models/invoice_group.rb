class InvoiceGroup < ActiveRecord::Base
  has_many :invoice_group_links, dependent: :restrict_with_error
  has_many :invoices, through: :invoice_group_links

  validates_presence_of :name
end
