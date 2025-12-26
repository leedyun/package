require 'test_helper'
require 'contributors_stats/base'

describe ContributorsStats::Base do
  before do
    @tester = ContributorsStats::Base
  end

  it "logs messages" do
    tester = @tester.new
    tester.logger = ContributorsStats::ArrayLoggerExample.new
    tester.send(:log, 'something')
    tester.send(:log, 'nothing')
    tester.logger.data.must_equal(['something', 'nothing'])
  end

  it "loads plugins" do
    plugins = @tester.new.send(:plugins)
    plugins.must_be_kind_of(Pluginator::Group)
    plugins.types.size.must_be(:>=, 4)
    plugins.first_class('formatter', 'html').wont_be_nil
  end

  it "filters options" do
    example_input = {
      :gh_org => "railsisntaller",
      :nothing => "name",
    }
    example_output = {
      :gh_org => "railsisntaller"
    }
    plugins = @tester.new(example_input).send(:filter_options, 'reader')
    plugins.must_equal(example_output)
  end

end
