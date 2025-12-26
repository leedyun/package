require "test/unit"
require_relative "../../../it_tools/lib/it_tools/solr.rb"
require_relative "../../lib/it_tools/html_publish.rb"

class TestInteg1 < Test::Unit::TestCase
  def test_convert_upload
    converter = Website::MarkdownConverter.new
    file = "ruby"
    input = file + ".mmd"
    output = file + ".html"
    contents = File.open("testdata/" + input).read
    converted = converter.convert_markdown_contents contents
    solr_url = "http://127.0.0.1:8983/solr/"
    uploader = Solr::Upload.new(:solr_base_url => solr_url )
    uploader.upload_file(output, converted, output)
  end
end
