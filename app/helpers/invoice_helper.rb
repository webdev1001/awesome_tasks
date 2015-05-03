module InvoiceHelper
  def link_to_invoice(invoice, args = {})
    if args[:title].present?
      title = args[:title]
    elsif invoice.invoice_no?
      title = t(".Invoice", invoice_no: invoice.invoice_no)
    else
      title = T(".invoice_withid", id: invoice.id)
    end

    if can? :show, invoice
      link_to title, invoice_path(invoice)
    else
      title
    end
  end

  def translated_invoice_states
    {
      t(".draft") => :draft,
      t(".finished") => :finished,
      t(".sent") => :sent,
      t(".paid") => :paid
    }
  end

  def translated_invoice_state(invoice)
    translated_invoice_states.each do |state_text, state|
      return state_text if invoice.state.to_s == state.to_s
    end

    return ""
  end
end
