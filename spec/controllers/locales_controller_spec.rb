require "spec_helper"

describe LocalesController do
  it "#set" do
    post :set, locale: "da"
    I18n.locale.should eq :da
  end

  it "#set" do
    post :set, locale: "en"
    I18n.locale.should eq :en
  end
end
