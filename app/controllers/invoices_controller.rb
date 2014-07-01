class InvoicesController < ApplicationController
  before_filter :set_and_authorize_invoice
  
  def index
    @ransack_params = params[:q] || {}
    @ransack = Invoice.ransack(@ransack_params)
    @invoices = @ransack.result
  end
  
  def new
    @invoice = Invoice.new
  end
  
  def create
    @invoice = Invoice.new(invoice_params)
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
    if @invoice.destroy
      redirect_to invoices_path
    else
      flash[:error] = @invoice.errors.full_messages.join(". ")
      redirect_to invoice_path(@invoice)
    end
  end
  
  def pdf
    begin
      send_data @invoice.to_pdf, :filename => @invoice.filename, :type => @invoice.filetype, :disposition => "inline"
    rescue RuntimeError => e
      flash[:error] = e.message
      redirect_to :back
    end
  end
  
private
  
  def invoice_params
    params.require(:invoice).permit(:invoice_no, :date, :payment_at, :customer_id, :creditor_id, :invoice_type, :amount)
  end
  
  def set_and_authorize_invoice
    if params[:id]
      @invoice = Invoice.find(params[:id])
      authorize! action_name.to_sym, @invoice
    else
      authorize! action_name.to_sym, Invoice
    end
  end
end
