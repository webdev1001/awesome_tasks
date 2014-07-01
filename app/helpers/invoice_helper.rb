module InvoiceHelper
  def link_to_invoice invoice, args = {}
    if args[:title].present?
      title = args[:title]
    elsif invoice.invoice_no.present?
      title = _("Invoice %{invoice_no}", :invoice_no => invoice.invoice_no)
    else
      title = _("Invoice with ID %{id}", :id => invoice.id)
    end
    
    if can? :show, invoice
      link_to title, invoice_path(invoice)
    else
      title
    end
  end
end
