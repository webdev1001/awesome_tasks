class InvoiceLine < ActiveRecord::Base
  # Track changes.
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  belongs_to :invoice

  validates_presence_of :invoice, :title, :quantity, :amount

  after_save :update_invoice_price_after_save

  def amount_total
    amount.to_f * quantity.to_f
  end

private

  def update_invoice_price_after_save
    invoice.update_amount
  end
end
