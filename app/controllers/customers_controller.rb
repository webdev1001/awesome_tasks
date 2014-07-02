class CustomersController < ApplicationController
  before_filter :set_customer
  
  def index
    @ransack_params = params[:q] || {}
    @ransack = Customer.ransack(@ransack_params)
    @customers = @ransack.result.paginate(:page => params[:page], :per_page => 30)
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.new(customer_params)
    
    if @customer.save
      redirect_to customer_path(@customer)
    else
      flash[:error] = @customer.errors.full_messages.join(". ")
      render :new
    end
  end
  
  def update
    if @customer.update_attributes(customer_params)
      redirect_to customer_path(@customer)
    else
      flash[:error] = @customer.errors.full_messages.join(". ")
      render :edit
    end
  end
  
  def destroy
    @customer.destroy!
    redirect_to customers_path
  end
  
private
  
  def set_customer
    if params[:id]
      @customer = Customer.find(params[:id])
      authorize! action_name.to_sym, @customer
    end
  end
  
  def customer_params
    params.require(:customer).permit(:name, :email, :vat_no, :payment_info, :delivery_address,
      :delivery_zip_code, :delivery_city, :delivery_country, :invoice_address, :invoice_zip_code,
      :invoice_city, :invoice_country)
  end
end
