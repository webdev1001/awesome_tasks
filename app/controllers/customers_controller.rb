class CustomersController < ApplicationController
  before_filter :set_customer
  
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
    @customer.destroy
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
    params.require(:customer).permit(:name)
  end
end
