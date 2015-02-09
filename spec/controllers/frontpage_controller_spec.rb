require "spec_helper"

describe FrontpageController do
  render_views

  let!(:user){ create :user }
  let!(:task){ create :task }

  it "#index" do
    sign_in user
    get :index
    response.should be_success
  end
end
