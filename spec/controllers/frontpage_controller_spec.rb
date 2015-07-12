require "spec_helper"

describe FrontpageController do
  let!(:user){ create :user }
  let!(:task){ create :task }

  render_views

  before do
    sign_in user
  end

  describe "#index" do
    it 'renders as html' do
      get :index
      expect(response).to be_success
    end

    it 'renders as mobile' do
      set_mobile_agent
      get :index
      expect(controller.view_context.agent_mobile?).to eq true
      expect(response).to be_success
    end
  end
end
