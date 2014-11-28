module InvoiceGroupHelper
  def link_to_invoice_group(group)
    return "[#{_("no invoice-group")}]" unless group

    if can? :show, group
      link_to group.name, group
    else
      group.name
    end
  end
end
