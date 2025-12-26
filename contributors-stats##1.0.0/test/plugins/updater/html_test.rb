require 'test_helper'
require 'plugins/contributors_stats/updater/html'

def response(text)
%Q{<body><span class="contributors">
#{text}
</span></body>}
end

describe ContributorsStats::Updater::Html do
  before do
    @tester = ContributorsStats::Updater::Html
    @simple_content = %q{<body><span class="contributors"></span></body>}
  end

  it "responds to html files" do
    @tester.handles?("/path/to/a/file.html").must_equal(true)
  end

  it "responds to html.erb files" do
    @tester.handles?("/path/to/a/file.html.erb").must_equal(true)
  end

  it "does not respond to java files" do
    @tester.handles?("/path/to/a/file.java").must_equal(false)
  end

  it "uses default options" do
    tester = @tester.new("", [])
    tester.search.must_equal(@tester::DEFAULT_SEARCH)
    tester.replace.must_equal(@tester::DEFAULT_REPLACE)
  end

  it "uses given search option" do
    tester = @tester.new("", [], search: "search_me1")
    tester.search.must_equal("search_me1")
  end

  it "uses given replace option" do
    tester = @tester.new("", [], replace: "replace_me1")
    tester.replace.must_equal("replace_me1")
  end

  it "returns empty template for empty data" do
    result = @tester.update(@simple_content, [])
    result.must_equal(response(""))
  end

  it "returns new content for some data" do
    example_data = %q{<img url="far far away"/>}
    result = @tester.update(@simple_content, [example_data])
    result.must_equal(response(example_data))
  end

end
