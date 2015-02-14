class InvoiceLinesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_invoice

  def show
  end

  def new
  end

  def create
    if @invoice_line.save
      redirect_to invoice_path(@invoice)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @invoice_line.update_attributes(invoice_line_params)
      redirect_to invoice_path(@invoice)
    else
      render :edit
    end
  end

  def destroy
    unless @invoice_line.destroy
      flash[:error] = @invoice_line.errors.full_messages.join(". ")
    end

    redirect_to invoice_path(@invoice_line.invoice)
  end

private

  def invoice_line_params
    params.require(:invoice_line).permit(:title, :quantity, :amount)
  end

  def set_invoice
    @invoice = Invoice.find(params[:invoice_id])
    @invoice_line.invoice = @invoice
  end
end
