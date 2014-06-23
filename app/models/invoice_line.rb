class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
  
  validates_presence_of :invoice, :title, :quantity, :amount
  
  after_save :update_invoice_price_after_save
  
private
  
  def update_invoice_price_after_save
    invoice.update_amount
  end
end
