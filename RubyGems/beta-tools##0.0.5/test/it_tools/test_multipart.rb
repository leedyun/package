require "test/unit"
require 'pathname'
libpath = Pathname.new(
                       File.join(File.dirname(__FILE__), [".."]*2, "lib")
                       ).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)

require "it_tools/multipart"
module TestMultipart
  class TestPost < Test::Unit::TestCase
    def test_get_query
      mp = Multipart::Post.new
      mp.add_params("fenton" => "travers")
      query, header = mp.get_query
      query_should_be = "--0123456789ABLEWASIEREISAWELBA9876543210\r\nContent-Disposition: form-data; name=\"fenton\"\r\n\r\ntravers\r\n--0123456789ABLEWASIEREISAWELBA9876543210--"
      assert_equal( query_should_be, query )
      header_should_be = {"Content-Type"=>"multipart/form-data; boundary=0123456789ABLEWASIEREISAWELBA9876543210", "User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/523.10.6 (KHTML, like Gecko) Version/3.0.4 Safari/523.10.6"}
      assert_equal( header_should_be, header)
    end
    def test_add_file
      mp = Multipart::Post.new
      mp.add_params("Fenton" => "Travers")
      filename = "small.txt"
      contents = File.open("testdata/" + filename).read
      mp.add_file( filename, contents)
      query, header = mp.get_query
      expected_query = "--0123456789ABLEWASIEREISAWELBA9876543210\r\nContent-Disposition: form-data; name=\"Fenton\"\r\n\r\nTravers\r\n--0123456789ABLEWASIEREISAWELBA9876543210\r\nContent-Disposition: form-data; name=\"small.txt\"; filename=\"small.txt\"\r\nContent-Type: text/plain\r\n\r\nThis is a small file.\nFenton Oliver Travers.\n\r\n--0123456789ABLEWASIEREISAWELBA9876543210--"
      assert_equal(expected_query, query)
    end
  end
end
