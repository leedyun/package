require 'test_helper'
require 'plugins/contributors_stats/user_data/fetch'

describe ContributorsStats::UserData::Fetch do
  before do
    @tester = ContributorsStats::UserData::Fetch
    @tester.send(:configure_path, File.expand_path("../../../fixtures-gh", __FILE__), ".json")
  end

  it "loads user data" do
    result = @tester.load("mpapis", {"url" => "users/mpapis.json"}, 20)
    result.keys.size.must_equal(30)
    result["name"].must_equal("Michal Papis")
  end

end
