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
    expect(response).to be_success
  end

  it 'renders show as mobile' do
    get :show, id: organization.id, mobile: 1
    expect(response).to be_success
  end

  it "#index" do
    organization
    get :index
    expect(response).to be_success
    expect(assigns(:organizations)).to eq [organization]
  end

  it 'renders index as mobile' do
    organization
    get :index, mobile: 1
    expect(response).to be_success
    expect(assigns(:organizations)).to eq [organization]
  end

  it "#destroy" do
    delete :destroy, id: organization.id
    response.location.should eq organizations_url
  end

  it "#edit" do
    get :edit, id: organization.id
    expect(response).to be_success
  end

  it 'renders edit as mobile' do
    get :edit, id: organization.id, mobile: 1
    expect(response).to be_success
  end

  it "#new" do
    get :new
    expect(response).to be_success
  end

  it 'renders new as mobile' do
    get :new, mobile: 1
    expect(response).to be_success
  end
end
