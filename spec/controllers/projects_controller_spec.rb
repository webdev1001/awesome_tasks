require "spec_helper"

describe ProjectsController do
  let(:project){ create :project, organization: organization }
  let(:organization){ create :organization }
  let(:user_admin){ create :user_admin }

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
      post :create, project: {name: "Test project", organization_id: organization.id}
      controller.flash.to_a.should eq []
      latest_project = Project.last
      latest_project.name.should eq "Test project"
      response.should redirect_to(latest_project)
    end

    it "#update" do
      patch :update, id: project.id, project: {name: "Test new name"}
      response.should redirect_to(project)
      controller.flash.to_a.should eq []
      project.reload.name.should eq "Test new name"
    end
  end
end
