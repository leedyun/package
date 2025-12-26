require "test/unit"
require_relative "../../lib/it_tools/sample"

class TestSample < Test::Unit::TestCase

  def test_lambda
    sam = Sample.new
    sam.func1
  end
end
