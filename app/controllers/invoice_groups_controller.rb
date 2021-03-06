class InvoiceGroupsController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_params = params[:q] || {}
    @ransack = InvoiceGroup.ransack(@ransack_params)

    @invoice_groups = @ransack.result
    @invoice_groups = @invoice_groups.accessible_by(current_ability)
    @invoice_groups = @invoice_groups.order(:name) unless @ransack_params[:s]
  end

  def show
    @ransack_values = params[:q] || {}
    @ransack = @invoice_group.invoices.ransack(@ransack_values)

    @invoices = @ransack.result.paginate(page: params[:page], per_page: 30)
    @invoices = @invoices.accessible_by(current_ability)
    @invoices = @invoices.order("invoices.id").reverse_order unless @ransack_values[:s]
  end

  def new
  end

  def create
    if @invoice_group.save
      redirect_to @invoice_group
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @invoice_group.update_attributes(invoice_group_params)
      redirect_to @invoice_group
    else
      render :edit
    end
  end

  def destroy
    destroy_model @invoice_group
  end

private

  def invoice_group_params
    params.require(:invoice_group).permit(:name)
  end
end
