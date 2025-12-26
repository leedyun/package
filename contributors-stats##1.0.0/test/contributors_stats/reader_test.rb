require 'test_helper'
require 'contributors_stats/reader'

describe ContributorsStats::Reader do
  before do
    @tester = ContributorsStats::Reader
  end

  it "loads data using single plugin single source" do
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    tester.load(:gh_repo, "railsinstaller/website")
    tester.raw_data.size.must_equal(10)
  end

  it "produces logs" do
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    tester.load(:gh_org, "railsinstaller")
    tester.logger.data.size.must_equal(3)
  end

  it "loads data using single plugin multiple sources" do
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    tester.load(:gh_repo, "railsinstaller/website")
    tester.load(:gh_repo, "railsinstaller/railsinstaller-nix")
    tester.raw_data.size.must_equal(12)
  end

  it "loads data using single plugin array of sources (single) - privately" do
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    tester.send(:parse_readers, gh_repo: "railsinstaller/website")
    tester.raw_data.size.must_equal(10)
  end

  it "loads data using single plugin array of sources (multiple) - privately" do
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:configure_path, File.expand_path("../../fixtures-gh", __FILE__), ".json")
    tester.send(:parse_readers, gh_repo: ["railsinstaller/website", "railsinstaller/railsinstaller-nix"])
    tester.raw_data.size.must_equal(12)
  end

  it "loads data using single plugin array of sources" do
    tester = @tester.new(
      :configure_path => [File.expand_path("../../fixtures-gh", __FILE__), ".json"],
      :logger => ContributorsStats::ArrayLoggerExample.new,
      :gh_repo => "railsinstaller/railsinstaller-nix"
    )
    tester.raw_data.size.must_equal(2)
  end

end
