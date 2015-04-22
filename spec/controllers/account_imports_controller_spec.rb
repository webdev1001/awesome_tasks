require "spec_helper"

describe AccountImportsController do
  let(:user_admin) { create :user_admin }
  let(:account) { create :account }
  let(:account_import) { create :account_import, account: account }

  render_views

  before do
    sign_in user_admin
  end

  it "#index" do
    account_import
    get :index, account_id: account.id
    expect(response).to be_success
    expect(assigns(:account_imports)).to eq [account_import]
  end

  it "#show" do
    get :show, account_id: account.id, id: account_import.id
    expect(response).to be_success
  end

  it "#new" do
    get :new, account_id: account.id
    expect(response).to be_success
  end

  it "#create" do
    post :create, account_id: account.id, account_import: valid_attributes

    created_account_import = assigns(:account_import)

    expect(response).to redirect_to account_account_import_url(created_account_import)
  end

  it "#edit" do
    get :edit, account_id: account.id, id: account_import.id
    expect(response).to be_success
  end

  it "#update" do
    put :update, account_id: account.id, id: account_import.id, account_import: valid_attributes
    expect(response).to redirect_to account_account_import_url(account_import)
  end

  it "#destroy" do
    delete :destroy, account_id: account.id, id: account_import.id
    expect(response).to redirect_to account_url(account)
  end
end
