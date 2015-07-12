require "spec_helper"

describe ProjectsController do
  let(:project) { create :project, organization: organization }
  let(:organization) { create :organization }
  let(:user_admin) { create :user_admin }
  let(:valid_attributes) { {
    name: "Test project",
    organization_id: organization.id,
    state: "active",
    deadline_at: 7.days.from_now.strftime("%Y-%m-%d"),
    price_per_hour: 200,
    price_per_hour_transport: 150,
    description: Forgery::LoremIpsum.words(20, random: true)
  } }

  render_views

  context "when logged in" do
    before do
      sign_in user_admin
    end

    it "#index" do
      get :index
      response.should be_success
    end

    it "#show" do
      get :show, id: project.id
      response.should be_success
    end

    it "#edit" do
      get :edit, id: project.id
      response.should be_success
    end

    it "#destroy" do
      delete :destroy, id: project.id
      response.should redirect_to(projects_url)
    end

    it "#create" do
      post :create, project: valid_attributes
      flash.to_a.should eq []
      latest_project = Project.last
      latest_project.name.should eq "Test project"
      response.should redirect_to(latest_project)
    end

    it "#update" do
      patch :update, id: project.id, project: valid_attributes
      response.should redirect_to(project)
      flash.to_a.should eq []
      project.reload.name.should eq "Test project"
    end

    it "#assigned_users" do
      get :assigned_users, id: project.id
      response.should be_success
    end
  end
end
