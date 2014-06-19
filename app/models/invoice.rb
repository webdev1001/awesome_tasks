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
end
