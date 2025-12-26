require 'test_helper'
require 'contributors_stats/calculator'

describe ContributorsStats::Calculator do
  before do
    @tester = ContributorsStats::Calculator
  end

  it "initializes user_data_type" do
    tester = @tester.new(:user_data => :fetch)
    tester.user_data_type.must_equal(:fetch)
  end

  it "calculates contributions" do
    tester = @tester.new
    tester.send(:contributions, [{"contributions" => 2}, {"contributions" => 3}]).must_equal(5)
  end

  it "calculates user_data" do
    data = [
      {"contributions" => 2, "url" => "users/mpapis.json", "avatar_url" => "mpapis-avatar.jpg"},
      {"contributions" => 4},
    ]
    expected = {
      "avatar_url"=>"mpapis-avatar.jpg",
      "name"=>"mpapis",
      "url"=>"users/mpapis.json",
      "html_url"=>"https://github.com/mpapis",
      "contributions"=>6
    }
    tester = @tester.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    result = tester.send(:user_data, "mpapis", data)
    result.must_equal(expected)
  end

  it "calculates data" do
    raw_data = [
      {"login" => "mpapis", "contributions" => 2, "url" => "users/mpapis.json", "avatar_url" => "mpapis-avatar.jpg"},
      {"login" => "mpapis", "contributions" => 5},
    ]
    expected = [["mpapis", {
      "avatar_url"=>"mpapis-avatar.jpg",
      "name"=>"mpapis",
      "url"=>"users/mpapis.json",
      "html_url"=>"https://github.com/mpapis",
      "contributions"=>7
    } ]]
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    tester.instance_variable_set(:@raw_data, raw_data)
    tester.send(:calculated_data)
    tester.data.must_equal(expected)
  end

  it "invokes formatter" do
    data = [["mpapis", {
      "avatar_url"=>"mpapis-avatar.jpg",
      "name"=>"mpapis",
      "url"=>"users/mpapis.json",
      "html_url"=>"https://github.com/mpapis",
      "contributions"=>7
    }]]
    tester = @tester.new
    tester.instance_variable_set(:@data, data)
    tester.format.kind_of?(ContributorsStats::Formatter).must_equal(true)
  end

end
