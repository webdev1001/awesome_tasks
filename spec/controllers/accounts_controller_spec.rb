require "spec_helper"

describe AccountsController do
  let(:account) { create :account }
  let(:user_admin) { create :user_admin }
  let(:valid_params) { {name: "Test name"} }

  render_views

  before do
    sign_in user_admin
  end

  it "#index" do
    account
    get :index
    expect(assigns(:accounts)).to eq [account]
    expect(response).to be_success
  end

  it "#show" do
    get :show, id: account.id
    expect(response).to be_success
  end

  it "#new" do
    get :new
    expect(response).to be_success
  end

  it "#create" do
    post :create, account: valid_params

    created_account = assigns(:account)
    expect(created_account).to be_valid

    expect(response).to redirect_to account_url(created_account)
  end

  it "#edit" do
    get :edit, id: account.id
    expect(response).to be_success
  end

  it "#update" do
    put :update, id: account.id, account: valid_params
    expect(response).to redirect_to account_url(account)
  end

  it "#destroy" do
    delete :destroy, id: account.id
    expect { account.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(response).to redirect_to accounts_url
  end
end
