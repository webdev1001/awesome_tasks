require "spec_helper"

describe UserReferences do
  let!(:user){ create :user, username: "Kasper Johansen" }

  it "parses usernames" do
    text = "[Kasper Johansen] is a nice person."

    result = UserReferences.new(text: text).parse_user_references
    result.should eq "[[USER:#{user.id}]] is a nice person."
  end

  it "unparses usernames" do
    text = "[[USER:#{user.id}]] is a nice person."

    result = UserReferences.new(text: text).unparse_user_references(html: true)
    result.should eq "<a href=\"/users/#{user.id}\">Kasper Johansen</a> is a nice person."
  end
end
