require 'test_helper'
require 'plugins/contributors_stats/reader/gh_repo'

describe ContributorsStats::Reader::GhRepo do
  before do
    @tester = ContributorsStats::Reader::GhRepo
    @tester.send(:configure_path, File.expand_path("../../../fixtures-gh", __FILE__), ".json")
  end

  it "loads repository" do
    railsinstaller_user_names = %w{
      acco alexch drnic edwardchiu38 emachnic gpxl jc00ke mpapis veganstraightedge wayneeseguin
    }
    result = @tester.load("railsinstaller/website")
    result.size.must_equal(10)
    result.map(&:class).uniq.must_equal([Hash])
    result.map{|user| user["login"]}.uniq.sort.must_equal(railsinstaller_user_names)
  end

  it "loads repository with block" do
    railsinstaller_repo_names = %w{
      railsinstaller/website
    }
    counter = []
    @tester.load("railsinstaller/website") do |data, name|
      counter << name
    end
    counter.sort.must_equal(railsinstaller_repo_names)
  end

end
