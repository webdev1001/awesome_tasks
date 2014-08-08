class InvoiceLinesController < ApplicationController
  before_filter :set_invoice
  load_and_authorize_resource

  def new
    @invoice_line = @invoice.invoice_lines.new
  end

  def create
    @invoice_line = @invoice.invoice_lines.new(invoice_line_params)

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
    if !@invoice_line.destroy
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
  end
end
