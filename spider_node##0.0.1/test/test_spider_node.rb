require 'test/unit'
require 'spider-node'


class TestSpiderNode < Test::Unit::TestCase
  def test_check_node
    Spider::Node.check_node
  end

  def test_version
    assert { Spider::Node.spider_version >= '0.1.5' }
  end

  def test_compile_file_in_success
    file = File.expand_path('data/hello.spider', File.dirname(__FILE__))
    subject = Spider::Node.compile_file(file)

    assert { subject.exit_status == 0 }
    assert { subject.success? }
    assert { subject.js == %Q{$traceurRuntime.ModuleStore.getAnonymousModule(function() {\n  \"use strict\";\n  console.log(\"Hello world!\");\n  return {};\n});\n\n//# sourceMappingURL=hello.map\n} }
    assert { subject.stdout == '' }
    assert { subject.stderr == '' }
  end

  def test_compile
    subject = Spider::Node.compile('var a = 5;')

    assert { subject != '' }
    assert { subject != nil }
  end

end
