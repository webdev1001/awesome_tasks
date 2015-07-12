class ChangeInvoiceGroupRelationToMany < ActiveRecord::Migration
  def up
    Invoice.find_each do |invoice|
      next unless invoice.invoice_group_id
      InvoiceGroupLink.find_or_create_by!(invoice: invoice, invoice_group_id: invoice.invoice_group_id)
    end

    remove_column :invoices, :invoice_group_id
  end

  def down
    add_column :invoices, :invoice_group_id, :integer
    add_index :invoices, :invoice_group_id

    Invoice.find_each do |invoice|
      first_group = invoice.invoice_groups.first
      next unless first_group
      invoice.update_column(:invoice_group_id, first_group.id)
    end
  end
end
