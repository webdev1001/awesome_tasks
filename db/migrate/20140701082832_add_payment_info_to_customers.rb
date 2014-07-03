class AddPaymentInfoToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :payment_info, :text, :after => :vat_no
  end
end
