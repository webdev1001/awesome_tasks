module InvoiceGroupHelper
  def link_to_invoice_group group
    return "[#{_("no invoice-group")}]" unless group
    link_to group.name, group
  end
end
