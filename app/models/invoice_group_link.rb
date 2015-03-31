class InvoiceGroupLink < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :invoice_group

  validates_uniqueness_of :invoice_group_id, scope: :invoice_id
end
