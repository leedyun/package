require 'test_helper'
require 'contributors_stats/formatter'

def with_temp_file(name: 'contributors_stats', extension: "")
  file = Tempfile.new([name, extension])
  begin
     yield file if block_given?
  ensure
     file.close
     file.unlink
  end
end

describe ContributorsStats::Formatter do
  before do
    @tester = ContributorsStats::Formatter
    @example_content = [
      "<a href=\"https://github.com/mpapis\" title=\"mpapis - 7\"><img src=\"mpapis-avatar.jpg\" alt=\"mpapis - 7\"/></a>"
    ]
  end

  it "loads plugins" do
    plugins = @tester.allocate.send(:plugins)
    plugins.must_be_kind_of(Pluginator::Group)
    plugins.types.size.must_be(:>=, 4)
    plugins.first_class('updater', 'html').wont_be_nil
  end

  it "invokes formatter" do
    data = [["mpapis", {
      "avatar_url"=>"mpapis-avatar.jpg",
      "name"=>"mpapis",
      "url"=>"users/mpapis.json",
      "html_url"=>"https://github.com/mpapis",
      "contributions"=>7
    }]]
    tester = @tester.new(data, :html)
    tester.content.must_equal(@example_content)
  end

  it "saves to file" do
    with_temp_file do |file|
      tester = @tester.allocate
      tester.instance_variable_set(:@content, @example_content)
      tester.save(file.path)
      file.readlines.must_equal(@example_content)
    end
  end

  it "updates files - internal" do
    with_temp_file do |file|
      tester = @tester.allocate
      File.open(file.path, "w") {|f| f.write("anything") }
      tester.send(:update_file, file.path) do |text|
        text.gsub(/a/, "b")
      end
      File.read(file.path).must_equal("bnything")
    end
  end

  it "updates files - with plugins" do
    content_start = %q{<body><span class="contributors">}
    content_end   = %q{</span></body>}
    with_temp_file(extension: ".html") do |file|
      tester = @tester.allocate
      File.open(file.path, "w") {|f| f.write("#{content_start}#{content_end}\n") }
      tester.instance_variable_set(:@content, @example_content)
      tester.update(file.path)
      File.read(file.path).must_equal(<<-EXPECTED)
#{content_start}
#{@example_content * "\n"}
#{content_end}
EXPECTED
    end
  end

end
