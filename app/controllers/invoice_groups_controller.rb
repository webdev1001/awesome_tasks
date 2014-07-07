class InvoiceGroupsController < ApplicationController
  before_filter :set_invoice_group
  
  def index
    @ransack_params = params[:q] || {}
    @ransack = InvoiceGroup.ransack(@ransack_params)
    
    @invoice_groups = @ransack.result
    @invoice_groups = @invoice_groups.order(:name) unless @ransack_params[:s]
  end
  
  def show
  end
  
  def new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
private
  
  def invoice_group_params
    params.require(:invoice_group).permit(:name)
  end
  
  def set_invoice_group
    if params[:id].to_i > 0
      @invoice_group = InvoiceGroup.find(params[:id])
      authorize! action_name.to_sym, @invoice_group
    else
      authorize! action_name.to_sym, InvoiceGroup
    end
  end
end
