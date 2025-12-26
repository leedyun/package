# -*- coding: utf-8 -*-
require "test/unit"
require 'pathname'
libpath = Pathname.new(
                       File.join(File.dirname(__FILE__), [".."]*2, "lib")
                       ).cleanpath.to_s
$:.unshift(libpath) unless $:.include?(libpath)

require "it_tools/shared"

module TestSharedTool
  class TestRegularExpression < Test::Unit::TestCase
    $debug = 0
    $re = SharedTool::RegularExpression.new "testdata/pom.xml"
    def test_first_occurence
      regex = /<version>(.*)-SNAPSHOT<\/version>/
      version = $re.first_occurrence( regex)
      assert_equal("0.9.1", version)
    end
  end
end

class TestString < Test::Unit::TestCase
  def test_remove_non_ascii_1
    file = File.open "testdata/utf8_chars.txt"
    contents = file.read
    assert_equal("Oracle® Data\n", contents)
    contents = contents.remove_non_ascii
    assert_equal("Oracle Data\n",contents)
  end
  def test_remove_non_ascii_2
    file = File.open "testdata/ruby.mmd"
    contents = file.read
    contents = contents.remove_non_ascii
  end
end
