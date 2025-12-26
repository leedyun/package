require "test/unit"

require_relative "../../lib/it_tools/environment"

module TestDeployment
  class TestEnvironment < Test::Unit::TestCase
    $env = Environment.new(:debug => false)
    def test_initialize
      flag = '-s'
      value = '/home/fenton/projects/autoSR2-EAR'
      ARGV[0] = flag
      ARGV[1] = value
      en = Environment.new
      assert_equal en.ops[:source_folder], value
    end
    def test_get_deploy_dir
      assert_equal('/scratch/ngsp/hrmsToCrmod', $env.get_deploy_dir('dev'))
    end
    def test_set_options
      deploy = Environment.new
      debug = deploy.ops[:debug]
      assert_equal(false, debug)
      deploy.set_options(:debug => true)
      debug = deploy.ops[:debug]
      assert_equal(true, debug)
    end
    def test_set_options_2
      to = TestDeployment::TestOptions.new("Junk")
      ops = to.test_parse_options
      env = Environment.new(ops)
      e = env.ops[:environment]
      d = env.ops[:debug]
      assert_equal('loc', e)
      assert_equal(false, d)
    end

    def test_get_deploy_command
      enviro = Environment.new(:debug => false)
      env = "dev"
      deploy_command = enviro.get_deploy_command(env, "testdata/assembly_pom.xml")
      expected = "rsync -avP --stats "
      expected += "target/hrmsToCrmodUserDataIntegration-jar-with-dependencies.jar "
      expected += "ftravers@sta00418.us.oracle.com:/scratch/ngsp/hrmsToCrmod/"
      expected += "hrmsToCrmodUserDataIntegration-0.0.90.jar"
      assert_equal(expected, deploy_command)
      contents = File.open("testdata/pom.xml").read
      deploy_command = enviro.get_deploy_command(env, contents, :use_scp => true)
      assert_equal("scp target/crmod-ws-wrapper.jar ftravers@sta00418.us.oracle.com:/scratch/ngsp/hrmsToCrmod/hrm-0.0.90.jar", deploy_command)

      contents = File.open("testdata/pom.xml").read
      deploy_command = enviro.get_deploy_command(env, contents, :use_scp => true)
      expected = "rsync -avP --stats "
      expected += "target/autoSR2-EAR.ear "
      expected += "ftravers@sta00418.us.oracle.com:/scratch/ngsp/hrmsToCrmod/"
      expected += "autoSR2-EAR-0.3.0.ear"
      assert_equal(expected, deploy_command)
    end

  end

  class TestOptions < Test::Unit::TestCase
    def test_initialize
      clas = Options.new
      assert_equal(clas.options[:debug], false)
      assert_equal(clas.options[:environment], 'loc')
      assert_equal(clas.options[:indexer_url], nil)
    end

    def test_parse_options
      loc = 'loc'
      e = '-e'
      ARGV[0] = e
      ARGV[1] = loc

      deployment = Options.new
      env = deployment.options[:environment]

      assert_equal(loc, env)
      return deployment.options
    end
  end
end

