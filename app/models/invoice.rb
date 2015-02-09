class Invoice < ActiveRecord::Base
  include ::ViewRenderer # Used for PDF generation.

  # Track changes.
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.try(:current_user) }

  belongs_to :creditor, class_name: "Organization"
  belongs_to :invoice_group
  belongs_to :organization
  belongs_to :user

  has_many :invoice_lines, dependent: :destroy
  has_many :uploaded_files, as: :resource, dependent: :destroy

  validates_presence_of :user, :date, :invoice_group, :invoice_type

  scope :debit, ->{ where(invoice_type: "debit") }
  scope :credit, ->{ where(invoice_type: "credit") }
  scope :purchase, ->{ where(invoice_type: "purchase") }

  before_validation :before_validation_set_price_if_not_given

  state_machine :state, :initial => :draft do
    after_transition on: :finish do |invoice|
      invoice.create_activity action: "finished"
    end

    after_transition on: :register_as_sent do |invoice|
      invoice.create_activity action: "registered_as_sent"
    end

    after_transition on: :register_as_paid do |invoice|
      invoice.create_activity action: "registered_as_paid"
    end

    event :finish do
      transition :draft => :finished
    end

    event :register_as_sent do
      transition [:draft, :finished] => :sent
    end

    event :register_as_paid do
      transition [:draft, :sent] => :paid
    end
  end

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
    if invoice_no.present?
      filename_str = _("Invoice %{invoice_no}", invoice_no: invoice_no)
    else
      filename_str = _("Invoice ID %{id}", id: id)
    end

    filename_str << ".pdf"
    return filename_str
  end

  def filetype
    return "application/pdf"
  end

  def to_pdf
    raise _("No invoice number has been set.") unless invoice_no.present?
    raise _("No invoice-date has been set.") unless date.present?
    raise _("No payment-date has been set.") unless payment_at.present?
    raise _("No creditor has been set.") unless creditor

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
    if no_vat?
      0.0
    else
      amount.to_f * 0.25
    end
  end

  def amount_total
    amount.to_f + amount_vat
  end

  def add_uninvoiced_timelogs_for_user(user)
    timelogs = Timelog
      .joins(:project)
      .includes(:project)
      .where(projects: {organization_id: organization_id})
      .readonly(false)
      .not_invoiced

    timelogs.find_each do |timelog|
      time = Baza::Dbtime.new(timelog.time.strftime("%H:%M:%S"))
      time_transport = Baza::Dbtime.new(timelog.time_transport.strftime("%H:%M:%S"))

      if time.total_secs > 0
        invoice_line = invoice_lines.create!(
          title: "[task:#{timelog.task_id}] - [timelog:#{timelog.id}]: #{timelog.comment.truncate(100)}".strip,
          quantity: time.hours_total,
          amount: timelog.project.price_per_hour,
          timelog: timelog
        )
      end

      if time_transport.total_secs > 0 && timelog.project.price_per_hour_transport > 0
        invoice_line = invoice_lines.create!(
          title: "[task:#{timelog.task_id}] - [timelog:#{timelog.id}]: #{_("Transport")}",
          quantity: time_transport.hours_total,
          amount: timelog.project.price_per_hour_transport,
          timelog: timelog
        )
      end

      timelog.update_attributes!(
        invoiced: true,
        invoiced_at: Time.zone.now,
        invoiced_by_user: user
      )
    end
  end

private

  def before_validation_set_price_if_not_given
    self.amount = 0.0 unless amount.present?
  end
end
