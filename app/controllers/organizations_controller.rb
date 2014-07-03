class OrganizationsController < ApplicationController
  before_filter :set_organization
  
  def index
    @ransack_params = params[:q] || {}
    @ransack = Organization.ransack(@ransack_params)
    @organizations = @ransack.result.paginate(:page => params[:page], :per_page => 30)
  end
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      redirect_to organization_path(@organization)
    else
      flash[:error] = @organization.errors.full_messages.join(". ")
      render :new
    end
  end
  
  def update
    if @organization.update_attributes(organization_params)
      redirect_to organization_path(@organization)
    else
      flash[:error] = @organization.errors.full_messages.join(". ")
      render :edit
    end
  end
  
  def destroy
    @organization.destroy!
    redirect_to organizations_path
  end
  
private
  
  def set_organization
    if params[:id]
      @organization = Organization.find(params[:id])
      authorize! action_name.to_sym, @organization
    end
  end
  
  def organization_params
    params.require(:organization).permit(:name, :email, :vat_no, :payment_info, :delivery_address,
      :delivery_zip_code, :delivery_city, :delivery_country, :invoice_address, :invoice_zip_code,
      :invoice_city, :invoice_country, :customer, :creditor)
  end
end
