require 'test_helper'
require 'contributors_stats'

describe ContributorsStats do
  it "loads calculator" do
    tester = ContributorsStats.load
    tester.kind_of?(ContributorsStats::Calculator).must_equal(true)
  end
  it "passes by options" do
    tester = ContributorsStats.load(:user_data => :fetch)
    tester.user_data_type.must_equal(:fetch)
  end
end
