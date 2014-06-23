module InvoiceHelper
  def link_to_invoice invoice
    title = _("Invoice %{id}", :id => invoice.id)
    
    if can? :show, invoice
      link_to title, invoice_path(invoice)
    else
      title
    end
  end
end
