class Invoice < ActiveRecord::Base
  include ::ViewRenderer # Used for PDF generation.
  
  belongs_to :creditor, :class_name => "Customer"
  belongs_to :customer
  belongs_to :user
  
  has_many :invoice_lines, :dependent => :destroy
  has_many :uploaded_files, :as => :resource, :dependent => :destroy
  
  validates_presence_of :user, :amount, :date, :invoice_type
  
  scope :debit, ->{ where(:invoice_type => "debit") }
  scope :credit, ->{ where(:invoice_type => "credit") }
  scope :purchase, ->{ where(:invoice_type => "purchase") }
  
  def self.translated_invoice_types
    return {
      _("Debit") => "debit",
      _("Credit") => "credit",
      _("Purchase") => "purchase"
    }
  end
  
  def translated_invoice_type
    Invoice.translated_invoice_types.each do |title, type_i|
      return title if type_i == invoice_type.to_s
    end
    
    return ""
  end
  
  def update_amount
    total = 0.0
    invoice_lines.find_each do |invoice_line|
      total += invoice_line.quantity.to_f * invoice_line.amount.to_f
    end
    
    self.amount = total
    save!
  end
  
  def filename
    filename_str = _("Invoice %{id}", :id => id)
    filename_str << ".pdf"
    return filename_str
  end
  
  def filetype
    return "application/pdf"
  end
  
  def to_pdf
    html = render_pdf_to_string
    
    header_html = render_pdf_to_string '_header'
    header_file = Tempfile.new(['header', '.html'])
    header_file.write(header_html)
    header_file.close
    
    footer_html = render_pdf_to_string '_footer'
    footer_file = Tempfile.new(['footer', '.html'])
    footer_file.write(footer_html)
    footer_file.close
    
    pdf = PDFKit.new(html, {
      "header-html" => "file://#{header_file.path}",
      "footer-html" => "file://#{footer_file.path}"
    }).to_pdf
    
    header_file.unlink
    footer_file.unlink
    
    return pdf
  end
  
  def amount_vat
    amount.to_f * 0.25
  end
  
  def amount_total
    amount.to_f * 1.25
  end
end
