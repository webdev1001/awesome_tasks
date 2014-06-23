require "spec_helper"

describe CustomersController do
  let(:customer){ create :customer }
  let(:admin){ create :user_admin}
  
  before do
    sign_in admin
  end
  
  render_views
  
  it "#show" do
    get :show, :id => customer.id
    response.should be_success
  end
  
  it "#index" do
    customer
    get :index
    response.should be_success
  end
  
  it "#destroy" do
    delete :destroy, :id => customer.id
    response.location.should eq customers_url
  end
  
  it "#edit" do
    get :edit, :id => customer.id
    response.should be_success
  end
end
