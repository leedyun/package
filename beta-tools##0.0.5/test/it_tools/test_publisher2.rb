require 'fileutils'
require "test/unit"
require_relative "../../lib/it_tools/publisher2"
require_relative 'test_publisher2_support'

class TestPublisher2 < Test::Unit::TestCase
  def setup
    ps = PublisherSupport.new
    ps.before
  end
  def teardown
    ps = PublisherSupport.new
    ps.after
  end
  def test_which_files_have_changed_since_last_publish
    src_dir = 'testdata/src_dir'
    target_dir = 'testdata/target_dir'
    publisher = Publisher::Markdown.new
    FileUtils.touch 'testdata/src_dir/file1.mmd'
    newer_files = publisher.get_newer_src_files( src_dir, target_dir, publisher.is_markdown_file, publisher.convert_to_html_filename)
    should_be = ["/home/fenton/projects/beta_tools/testdata/src_dir/file4.mmd",
 "/home/fenton/projects/beta_tools/testdata/src_dir/file1.mmd"]
    assert_equal should_be,newer_files
  end
  def test_convert_mmd_files
    src_dir = 'testdata/src_dir'
    target_dir = 'testdata/target_dir'
    publisher = Publisher::Markdown.new
    newer_files = publisher.get_newer_src_files( src_dir, target_dir, publisher.is_markdown_file, publisher.convert_to_html_filename)
    should_be = ["file1.mmd"]
    converted_files = publisher.convert_mmd_files(newer_files,target_dir)
  end
  def test_copy_images
    src_dir = 'testdata/src_dir/images'
    target_dir = 'testdata/target_dir/images'
    publisher = Publisher::Markdown.new
    newer_files = publisher.get_newer_src_files src_dir, target_dir
    should_be = ["/home/fenton/projects/beta_tools/testdata/src_dir/images/linux.jpeg"]
    assert_equal should_be,newer_files
  end
end

