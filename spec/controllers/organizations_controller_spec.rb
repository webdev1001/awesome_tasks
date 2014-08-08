require "spec_helper"

describe OrganizationsController do
  let(:organization){ create :organization }
  let(:admin){ create :user_admin}

  before do
    sign_in admin
  end

  render_views

  it "#show" do
    get :show, id: organization.id
    response.should be_success
  end

  it "#index" do
    organization
    get :index
    response.should be_success
  end

  it "#destroy" do
    delete :destroy, id: organization.id
    response.location.should eq organizations_url
  end

  it "#edit" do
    get :edit, id: organization.id
    response.should be_success
  end

  it "#show" do
    get :show, id: organization.id
    response.should be_success
  end
end
