require "test/unit"
require_relative "../../lib/it_tools/publisher2"

class TestPublisher2 < Test::Unit::TestCase
  # integration test
  def test_which_files_have_changed_since_last_publish
    src_dir = 'testdata/src_dir'
    target_dir = 'testdata/target_dir'
    publisher = Publisher::Markdown.new
    newer_files = publisher.which_files_newer src_dir, target_dir
    p newer_files
  end
end
