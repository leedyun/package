# -*- coding: utf-8 -*-
require "test/unit"
require_relative "../../lib/it_tools/html_publish"

module TestWebsite
  class TestMarkdownConverter < Test::Unit::TestCase
    # integration test
    def test_send_to_indexer
      file = "java.html"
      contents = File.open("testdata/" + file).read
      mc = Website::MarkdownConverter.new :indexer_url => "http://127.0.0.1:8983/solr/"
      mc.send_to_indexer(file, contents)
    end
    def test_go
      mc = Website::MarkdownConverter.new :indexer_url => "http://127.0.0.1:8983/solr/"
      mc.go
    end
    # unit tests
    def test_convert_mmd
      contents = File.open("testdata/simple.mmd").read
      mc = Website::MarkdownConverter.new :indexer_url => "http://127.0.0.1:8983/solr/"
      actual = mc.convert_markdown_contents contents
      expected = "<div class=\"toc1\"><a href=\"#Hello\">1 - Hello</a></div><br/>\n\n<h1 id=\"Hello\">1 - Hello</h1>\n\n<p>Body</p>\n"
      assert_equal(expected, actual)
    end
    def test_intialize
      mc = Website::MarkdownConverter.new
    end
    def test_remove_non_ascii
      contents = File.open("testdata/utf8_chars.txt").read
      assert_equal "Oracle® Data\n", contents
      new_contents = contents.remove_non_ascii
      assert_equal "Oracle Data\n", new_contents
    end   
    def test_initialize
      eflag = '-e'
      loc = 'loc'
      ARGV[0] = eflag
      ARGV[1] = loc
      conv = Website::MarkdownConverter.new
      assert_not_equal nil, conv
      env = conv.ops[:environment]
      # assert_equal(loc, env, "Environment")
    end
    def test_set_options
      var = Website::MarkdownConverter.new
      assert_equal(false, var.ops[:debug])
      var.set_options(:debug => true)
      assert_equal(true, var.ops[:debug])
    end
  end
end


