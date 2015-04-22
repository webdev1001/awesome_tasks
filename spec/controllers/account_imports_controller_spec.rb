require "spec_helper"

describe AccountImportsController do
  let(:user_admin) { create :user_admin }
  let(:account) { create :account }
  let(:account_import) { create :account_import, account: account }
  let(:valid_attributes) { {
    uploaded_file_attributes: {
      file: fixture_file_upload(Rails.root.join("spec", "images", "kaspernj.jpg"), "image/jpeg")
    }
  } }

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

    expect(response).to redirect_to account_account_import_url(account, created_account_import)
  end

  it "#edit" do
    get :edit, account_id: account.id, id: account_import.id
    expect(response).to be_success
  end

  it "#update" do
    uploaded_file = account_import.uploaded_file
    put :update, account_id: account.id, id: account_import.id, account_import: valid_attributes

    updated_account_import = assigns(:account_import)
    expect(updated_account_import).to be_valid

    expect { uploaded_file.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response).to redirect_to account_account_import_url(account, account_import)
  end

  it "#destroy" do
    delete :destroy, account_id: account.id, id: account_import.id
    expect(response).to redirect_to account_url(account)
  end
end
