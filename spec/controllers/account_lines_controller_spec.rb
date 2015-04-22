require "spec_helper"

describe AccountLinesController do
  let(:account) { create :account }
  let(:account_line) { create :account_line, account: account }
  let(:user_admin) { create :user_admin }
  let(:valid_params) { {amount: 100.50, text: "test"} }

  render_views

  before do
    sign_in user_admin
  end

  it "#index" do
    account_line
    get :index, account_id: account.id
    expect(assigns(:account_lines)).to eq [account_line]
    expect(response).to be_success
  end

  it "#show" do
    get :show, account_id: account.id, id: account_line.id
    expect(response).to be_success
  end

  it "#new" do
    get :new, account_id: account.id
    expect(response).to be_success
  end

  it "#create" do
    post :create, account_id: account.id, account_line: valid_params

    created_account_line = assigns(:account_line)
    expect(created_account_line).to be_valid

    expect(response).to redirect_to account_account_line_url(account, created_account_line)
  end

  it "#edit" do
    get :edit, account_id: account.id, id: account_line.id
    expect(response).to be_success
  end

  it "#update" do
    put :update, account_id: account.id, id: account_line.id, account_line: valid_params
    expect(response).to redirect_to account_account_line_url(account, account_line)
  end

  it "#destroy" do
    delete :destroy, account_id: account.id, id: account_line.id
    expect { account_line.reload }.to raise_error(ActiveRecord::RecordNotFound)
    expect(response).to redirect_to account_url(account)
  end
end
