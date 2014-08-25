require "spec_helper"

describe "previous url" do
  let!(:user){ create :user_admin, email: "test@example.com", password: "123" }

  it "redirects to the previous url after successful login" do
    get "/invoices"
    response.should redirect_to new_user_session_url

    session[:previous_url].should eq invoices_url

    post "/users/sign_in", user: {email: "test@example.com", password: "123"}
    response.should redirect_to invoices_url
  end
end
