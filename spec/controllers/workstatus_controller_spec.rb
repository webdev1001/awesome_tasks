require "spec_helper"

describe WorkstatusController do
  let!(:user){ create :user }
  let!(:timelog){ create :timelog, user: user }

  before do
    sign_in user
  end

  it "#index" do
    get :index
    expect(response).to be_success
  end
end
