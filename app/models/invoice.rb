class Invoice < ActiveRecord::Base
  belongs_to :customer
  belongs_to :user
  
  has_many :invoice_lines
  
  validates_presence_of :user, :amount, :date, :invoice_type
  
  def self.translated_invoice_types
    return {
      _("Debit") => "debit",
      _("Credit") => "credit",
      _("Purchase") => "purchase"
    }
  end
  
  def translated_invoice_type
    Invoice.translated_invoice_types.each do |title, type_i|
      return title if type_i == invoice_type.to_s
    end
    
    return ""
  end
  
  def update_amount
    total = 0.0
    invoice_lines.each do |invoice_line|
      total = invoice_line.quantity * invoice_line.amount
    end
    
    self.amount = total
    save!
  end
end
