class OrganizationsController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_params = params[:q] || {}
    @ransack = Organization.ransack(@ransack_params)

    @organizations = @ransack.result.paginate(page: params[:page], per_page: 30)
    @organizations = @organizations.accessible_by(current_ability)
    @organizations = @organizations.order(:name) unless @ransack_params[:s]
  end

  def new
  end

  def create
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
    destroy_model @organization
  end

  def show
  end

  def edit
  end

private

  def organization_params
    params.require(:organization).permit(:name, :email, :vat_no, :payment_info, :delivery_address,
      :delivery_zip_code, :delivery_city, :delivery_country, :invoice_address, :invoice_zip_code,
      :invoice_city, :invoice_country, :customer, :creditor)
  end
end
