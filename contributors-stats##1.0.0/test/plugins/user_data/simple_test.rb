require 'test_helper'
require 'plugins/contributors_stats/user_data/simple'

describe ContributorsStats::UserData::Simple do
  before do
    @tester = ContributorsStats::UserData::Simple
  end

  it "loads user data" do
    result = @tester.load("mpapis", {
      "url" => "users/mpapis.json",
      "avatar_url" => "https://secure.gravatar.com/avatar/3ec52ed58eb92026d86e62c39bdb7589?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"
    }, 20)
    result.keys.size.must_equal(5)
    result["name"].must_equal("mpapis")
  end

end
