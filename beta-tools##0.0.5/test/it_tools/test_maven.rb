require "test/unit"
require_relative "../../lib/it_tools/maven"

class TestMaven < Test::Unit::TestCase
  $mv = Maven.new "testdata/assembly_pom.xml"

  def test_initialize
    maven = Maven.new "testdata/assembly_pom.xml"
  end
  def test_get_artifact_type
    file = "testdata/ear_pom.xml"
    # artifact_type = $mv.
  end
  def test_get_artifact_name
    artifact_name = $mv.get_artifact_name("testdata/pom.xml")
    assert_equal("hrmsToCrmodUserDataIntegration.jar", artifact_name)
  end
  def test_get_built_artifact_name_with_version
    new_name = $mv.get_built_artifact_name_with_version("testdata/pom.xml")
    assert_equal("hrmsToCrmodUserDataIntegration-0.0.90.jar", new_name)
  end
  def test2_get_built_artifact_name_with_version
    new_name = $mv.get_built_artifact_name_with_version("testdata/pom.xml")
    assert_equal("hrmsToCrmodUserDataIntegration-0.0.90.jar", new_name)
  end
  def test_get_prev_version
    prev_ver = $mv.get_prev_version("0.8.4")
    assert_equal("0.8.3", prev_ver)
  end
end

