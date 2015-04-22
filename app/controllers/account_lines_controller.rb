class AccountLinesController < ApplicationController
  before_filter :set_account
  load_and_authorize_resource

  def index
    @ransack_values = params[:q] || {}

    if @account
      @ransack = @account.account_lines.ransack(@ransack_values)
    else
      @ransack = AccountLine.ransack(@ransack_values)
    end

    @account_lines = @ransack.result
    @account_lines = @account_lines.order(:rent_at).reverse_order unless params[:s]
    @account_lines = @account_lines.page(params[:page])
  end

  def show
  end

  def new
  end

  def create
    @account_line.account = @account

    if @account_line.save
      redirect_to account_account_line_url(@account, @account_line)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @account_line.update_attributes(account_line_params)
      redirect_to account_line_url(@account_line)
    else
      render :new
    end
  end

  def destroy
    if @account_line.destroy
      redirect_to account_url(@account_line.account)
    else
      flash[:error] = @account_line.errors.full_messages.join(". ")
      redirect_to account_line_url(@account_line)
    end
  end

private

  def account_line_params
    params.require(:account_line).permit(:text, :rent_at, :booked_at, :amount)
  end

  def set_account
    @account = Account.find(params[:account_id]) if params[:account_id].to_i > 0
    authorize! :show, @account
  end
end
