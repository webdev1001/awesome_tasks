require "spec_helper"

describe TimelogsController do
  render_views

  let(:task){ create :task }
  let(:timelog){ create :timelog, task: task }
  let(:admin){ create :user_admin }

  before do
    sign_in admin
  end

  it '#index' do
    timelog
    get :index
    expect(response).to be_success
    expect(assigns(:timelogs)).to eq [timelog]
  end

  it 'renders index as mobile' do
    timelog
    get :index, mobile: 1
    expect(response).to be_success
    expect(assigns(:timelogs)).to eq [timelog]
  end

  it "#new" do
    get :new, task_id: task.id
    expect(response).to be_success
  end

  it 'renders new as mobile' do
    get :new, task_id: task.id, mobile: 1
    expect(response).to be_success
  end

  it "#edit" do
    get :edit, task_id: task.id, id: timelog.id
    expect(response).to be_success
  end

  it 'renders edit as mobile' do
    get :edit, task_id: task.id, id: timelog.id, mobile: 1
    expect(response).to be_success
  end

  it "#destroy" do
    delete :destroy, task_id: task.id, id: timelog.id
    response.should redirect_to task
  end

  it "#update" do
    patch :update, task_id: task.id, id: timelog.id, timelog: {comment: Forgery::LoremIpsum.words(5) }
    response.should redirect_to task
  end

  context "#index" do
    context "finds timelogs where invoiced is 0" do
      let!(:timelog_invoiced_0){ create :timelog, invoiced: 0 }
      let!(:timelog_invoiced_nil){ create :timelog, invoiced: nil }

      it "works" do
        get :index, timelog: {invoiced: "only_not_invoiced"}
        assigns(:timelogs).should include timelog_invoiced_0
        assigns(:timelogs).should include timelog_invoiced_nil
      end
    end
  end
end
