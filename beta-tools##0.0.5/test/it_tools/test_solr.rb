require "test/unit"
require_relative "../../lib/it_tools/solr"

module TestSolr
  class TestUpload < Test::Unit::TestCase
    def test_upload_file
      filename = "java.html"
      contents = File.open("testdata/" + filename).read
      file_id = filename
      solr_base_url = "http://127.0.0.1:8983/solr/"
      solr_uploader = Solr::Upload.new :solr_base_url => solr_base_url
      solr_uploader.upload_file(filename, contents, file_id)
    end
  end
  class TestQuery < Test::Unit::TestCase
    query = Solr::Query.new
    params = { "query" => "web" }
    resp = query.do_query params
    p resp
  end
end

