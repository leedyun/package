require "test/unit"
require_relative "../../lib/it_tools/git"

module TestGit
  class TestHelper
    def test_setup_new_project
      git_helper = Git::Helper.new
      test_data_folder = ''
      git_helper.setup_new_project test_data_folder = ''
    end
    def add_new_project_to_gitosis proj_folder, proj_name, group, orig_gitosis, new_gitosis
      gitosis = Git::Gitosis.new
      gitosis.add_project_to_gitosis proj_folder, group, orig_gitosis, new_gitosis
      orig_gitosis = 'testdata/gitosis.conf'
      old_groups = gitosis.consume_file orig_gitosis
      fenton_grp = old_groups['fenton']
      projects = fenton_grp['writable']
      if /project_dir/ =~ projects 
        assert false, "Found #{proj_name}, in writable projects for group #{group}, when it shouldn't be there."
      end
      new_groups = gitosis.consume_file new_gitosis
      #p new_groups #########
      fenton_grp = new_groups['fenton']
      projects = fenton_grp['writable']
      unless /project_dir/ =~ projects 
        assert false, "Couldn't find project: #{proj_name}, in writable projects for group: #{group}, in file: #{new_gitosis}."
      end
    end
  end
  class TestGitosis < Test::Unit::TestCase
    def test_get_dirname
      git_helper = Git::Helper.new
      dirname = git_helper.get_dirname '.'
      assert_equal 'beta_tools', dirname
    end
    def test_consume_file
      gitosis = Git::Gitosis.new
      groups = gitosis.consume_file 'testdata/gitosis.conf'
      fenton_group = groups['fenton']
      writable = fenton_group['writable']
      members = fenton_group['members']
      assert_equal writable, "writable = myConfig project2 project3\n"
      assert_equal members, "members = fenton\n"
    end
    def test_write_file
      gitosis = Git::Gitosis.new
      orig_gitosis = 'testdata/gitosis.conf'
      groups = gitosis.consume_file orig_gitosis
      new_gitosis = 'testdata/gitosis2.conf'
      gitosis.write_gitosis_file new_gitosis, groups
      diff = `diff #{orig_gitosis} #{new_gitosis}`
      p diff
    end

    def test_anptg
      proj_name = 'project_dir'
      proj_folder = 'testdata/project_dir'
      group = 'fenton'
      new_gitosis = 'testdata/gitosis3.conf'
      orig_gitosis = 'testdata/gitosis.conf'
      helper = TestGit::TestHelper.new "abc"
      helper.add_new_project_to_gitosis proj_folder, proj_name, group, orig_gitosis, new_gitosis
      gitosis = Git::Gitosis.new
      groups = gitosis.consume_file 'testdata/gitosis3.conf'
      fenton_group = groups['fenton']
      writable = fenton_group['writable']
      members = fenton_group['members']  
      if /project_dir/ =~ writable
        has_project = true
      else
        has_project = false
      end
      assert has_project, "Couldn't find project: 'project_dir', in writable directive: #{writable}"
    end
    def test_remove_project_name_from_gitosis
      proj_name = 'project2'
      proj_folder = 'testdata/project_dir'
      group = 'fenton'
      new_gitosis = 'testdata/gitosis4.conf'
      orig_gitosis = 'testdata/gitosis.conf'
      gitosis = Git::Gitosis.new
      gitosis.remove_project_from_gitosis proj_name, group, orig_gitosis, new_gitosis
      groups = gitosis.consume_file 'testdata/gitosis4.conf'
      fenton_group = groups['fenton']
      writable = fenton_group['writable']
      members = fenton_group['members']
      if /project2/ =~ writable
        have_project = true
      else
        have_project = false
      end
      assert ! have_project, "Found project: 'project2', in writable directive: #{writable}"
    end
    def test_match
      regex = /^\[group (.*)\]/
      no_match = "abc 123"
      gitosis = Git::Gitosis.new
      matched = gitosis.match_line regex, no_match
      assert_nil matched
      match = "[group fenton]"
      matched = gitosis.match_line regex, match
      assert_equal matched, 'fenton'
    end
    def test_regex
      regex = /^\[group (.*)\]/
      match = "[group fenton]"
      regex =~ match
    end
  end
end
class Runner
    def rdebug_anptg
      proj_name = 'project_dir'
      proj_folder = '../../testdata/project_dir'
      group = 'fenton'
      new_gitosis = '../../testdata/gitosis3.conf'
      orig_gitosis = '../../testdata/gitosis.conf'
      test = TestGit::TestGitosis.new 'abc'
      test.add_new_project_to_gitosis proj_folder, proj_name, group, orig_gitosis, new_gitosis
    end
end
#runner = Runner.new
#runner.rdebug_anptg
