require 'test_helper'
require 'plugins/contributors_stats/reader/gh_org'

describe ContributorsStats::Reader::GhOrg do
  before do
    @tester = ContributorsStats::Reader::GhOrg
    @tester.send(:configure_path, File.expand_path("../../../fixtures-gh", __FILE__), ".json")
  end

  it "loads organisation" do
    railsinstaller_user_names = %w{
      acco alexch drnic edwardchiu38 emachnic gpxl jc00ke luigidr
      luislavena metaskills mpapis veganstraightedge wayneeseguin
    }
    result = @tester.load("railsinstaller")
    result.size.must_equal(18)
    result.map(&:class).uniq.must_equal([Hash])
    result.map{|user| user["login"]}.uniq.sort.must_equal(railsinstaller_user_names)
  end

  it "loads organisation with block" do
    railsinstaller_repo_names = %w{
      railsinstaller/railsinstaller-nix railsinstaller/railsinstaller-windows railsinstaller/website
    }
    counter = []
    @tester.load("railsinstaller") do |data, name|
      counter << name
    end
    counter.sort.must_equal(railsinstaller_repo_names)
  end

end
