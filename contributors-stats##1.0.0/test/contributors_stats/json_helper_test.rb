require 'test_helper'
require 'contributors_stats/json_helper'

class ContributorsStats::JsonHelperTester
  include ContributorsStats::JsonHelper
end

describe ContributorsStats::JsonHelper do
  before do
    @tester = ContributorsStats::JsonHelperTester.new
  end

  it "sets default prefix" do
    @tester.path_prefix.must_equal("https://api.github.com/")
  end

  it "uses given prefix and ads /" do
    @tester.send(:configure_path, "test_me", ".json")
    @tester.path_prefix.must_equal("test_me/")
  end

  it "sets default suffix" do
    @tester.path_suffix.must_equal("")
  end

  it "uses given suffix and ads ." do
    @tester.send(:configure_path, "test_me", "json")
    @tester.path_suffix.must_equal(".json")
  end

  it "builds url" do
    @tester.url_builder("anything").must_equal("https://api.github.com/anything")
  end

  it "builds custom url" do
    @tester.send(:configure_path, "test_me", "json")
    @tester.url_builder("anything").must_equal("test_me/anything.json")
  end

  describe ".load_json" do
    it "loads json from full path" do
      example = File.expand_path("../../fixtures-gh/users/mpapis.json", __FILE__)
      result = @tester.load_json(example)
      result["id"].must_equal(48054)
      result["gravatar_id"].must_equal("3ec52ed58eb92026d86e62c39bdb7589")
    end

    it "loads json from partial path" do
      @tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), "json")
      result = @tester.load_json("users/mpapis.json")
      result["id"].must_equal(48054)
      result["gravatar_id"].must_equal("3ec52ed58eb92026d86e62c39bdb7589")
    end

    it "loads json from minimal path" do
      @tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), "json")
      result = @tester.load_json("users/mpapis")
      result["id"].must_equal(48054)
      result["gravatar_id"].must_equal("3ec52ed58eb92026d86e62c39bdb7589")
    end

    it "does not loads json for missing URL" do
      lambda {
        @tester.load_json("https://api.github.com/mpapis/nonexisting/")
      }.must_raise(OpenURI::HTTPError)
    end

    it "does not loads json for broken path" do
      @tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), "json")
      lambda {
        @tester.load_json("nonexisting")
      }.must_raise(Errno::ENOENT)
    end
  end

end
