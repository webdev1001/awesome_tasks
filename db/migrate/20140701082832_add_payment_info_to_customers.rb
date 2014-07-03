class AddPaymentInfoToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :payment_info, :text, :after => :vat_no
  end
end
