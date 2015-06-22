class AccountsController < ApplicationController
  load_and_authorize_resource

  def index
    @ransack_values = params[:q] || {}
    @ransack = Account.ransack(@ransack_values)

    @accounts = @ransack.result
    @accounts = @accounts.page(params[:page])
    @accounts = @accounts.accessible_by(current_ability)
    @accounts = @accounts.order(:id) unless params[:s]
  end

  def show
  end

  def new
  end

  def create
    if @account.save
      redirect_to account_url(@account)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @account.update_attributes(account_params)
      redirect_to account_url(@account)
    else
      render :edit
    end
  end

  def destroy
    if @account.destroy
      redirect_to accounts_url
    else
      flash[:error] = @account.errors.full_messages.join(". ")
      redirect_to account_url(@account)
    end
  end

private

  def account_params
    params.require(:account).permit(:name)
  end
end
