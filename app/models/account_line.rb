class AccountLine < ActiveRecord::Base
  belongs_to :account
  belongs_to :invoice

  validates_presence_of :account

  scope :without_invoice, -> { where("account_lines.invoice_id IS NULL") }
end
