class InvoicesController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_params = params[:q] || {}
    @ransack = Invoice.ransack(@ransack_params)
    @invoices = @ransack.result
    @invoices = @invoices.order(:id).reverse_order unless @ransack_params[:s]
    @invoices = @invoices.paginate(page: params[:p], per_page: 40)
  end

  def new
    @invoice.payment_at = 1.week.since(Time.zone.now) unless params[:invoice] && params[:invoice][:payment_at]
  end

  def create
    @invoice.user = current_user

    if @invoice.save
      redirect_to invoice_path(@invoice)
    else
      flash[:error] = @invoice.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

  def update
    if @invoice.update_attributes(invoice_params)
      redirect_to invoice_path(@invoice)
    else
      flash[:error] = @invoice.errors.full_messages.join(". ")
      render :edit
    end
  end

  def show
  end

  def destroy
    destroy_model @invoice
  end

  def pdf
    begin
      send_data @invoice.to_pdf, filename: @invoice.filename, type: @invoice.filetype, disposition: "inline"
    rescue RuntimeError => e
      flash[:error] = e.message
      redirect_to :back
    end
  end

  def finish
    unless @invoice.finish
      flash[:error] = @invoice.errors.full_messages.join(". ")
    end

    redirect_to @invoice
  end

  def register_as_sent
    unless @invoice.register_as_sent
      flash[:error] = @invoice.errors.full_messages.join(". ")
    end

    redirect_to @invoice
  end

  def register_as_paid
    unless @invoice.register_as_paid
      flash[:error] = @invoice.errors.full_messages.join(". ")
    end

    redirect_to @invoice
  end

private

  def invoice_params
    params.require(:invoice).permit(:invoice_group_id, :invoice_no, :state, :date, :payment_at, :organization_id, :creditor_id, :invoice_type, :amount, :no_vat)
  end
end
