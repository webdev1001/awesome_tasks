class AccountImportsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_account

  def index
  end

  def show
  end

  def new
    @account_import.account = @account
    @uploaded_file = @account_import.build_uploaded_file
  end

  def create
    @account_import.uploaded_file.user = current_user
    @account_import.uploaded_file.resource = @account_import

    if @account_import.save
      redirect_to account_account_import_url(@account, @account_import)
    else
      flash[:error] = @account_import.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

  def update
    if @account_import.update_attributes(account_import_params)
      redirect_to account_account_import_url(@account, @account_import)
    else
      render :edit
    end
  end

  def destroy
    if @account_import.destroy
      redirect_to account_url(@account)
    else
      flash[:error] = @account_import.errors.full_messages.join(". ")
      redirect_to account_account_import_url(@account, @account_import)
    end
  end

  def update_columns
    found = []
    params[:column_type].each do |column_no, column_type|
      next unless column_type.present?

      column = @account_import.account_import_columns.find_or_create_by(
        column_no: column_no,
        column_type: column_type
      )
      found << column.id
    end

    @account_import.account_import_columns.where("account_import_columns.id NOT IN (?)", found).destroy_all

    redirect_to account_account_import_url(@account, @account_import)
  end

  def execute
    result = @account_import.execute
    flash[:notice] = _("%{count} lines was imported.", count: result[:count])
    redirect_to account_account_import_url(@account, @account_import)
  end

private

  def account_import_params
    params.require(:account_import).permit(uploaded_file_attributes: [:file])
  end

  def set_account
    @account = Account.find(params[:account_id])
    @account_import.account = @account unless @account_import.account.present?
  end

  helper_method :rows
  def rows
    @account_import.rows do |row|
      yield row
    end
  end

  helper_method :selected_column_for_no
  def selected_column_for_no(no)
    @account_import.account_import_columns.where(column_no: no).first.try(:column_type) || ""
  end
end
