require "spec_helper"

describe LocalesController do
  describe "#update" do
    it "updates to danish" do
      post :create, locale: {locale: "da"}
      I18n.locale.should eq :da
    end

    it "updates to english" do
      post :create, locale: {locale: "en"}
      I18n.locale.should eq :en
    end
  end
end
