require 'logger'
require 'fileutils'
require 'git'


# This module should provide helper functions to make working with GIT
# easier.

module Git
  class Helper
    attr_accessor :ops, :log
    def initialize
      @ops = {}
      @log = Logger.new 'log.txt'
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::DEBUG
      end
    end

    # When executed in a new folder it will 
    # * initialize a git repository there.  
    # * It will add two remote repositories, an internal and an external repo.  
    # * It will add the project into gitosis (int/ext)
    # * and it will do an initial commit, into either the internal or exteral repository, depending if you are on the VPN or not.
    def setup_new_project project_dir = '.', int_gitosis_dir = '../gitosis-admin', ext_gitosis_dir = '../spicevan/gitosis-admin', int_repo = 'git@linux1.hk.oracle.com', ext_repo = 'ft_git3@spicevan.com', gitosis_group = 'beta_projects'
      dirname = get_dirname project_dir
      
      @log.info "Project dir: " + dirname
      g = Git.init project_dir
      repo_tail =  ":" + dirname + ".git"
      g.add_remote 'origin', int_repo + repo_tail
      g.add_remote 'spicevan', ext_repo + repo_tail
      g.add '.'
      g.commit 'initial commit'

      gitosis = Git::Gitosis.new
      gitosis_conf = 'gitosis.conf'
      remote_name = 'spicevan'
      gitosis_file = File.join ext_gitosis_dir, gitosis_conf
      gitosis.add_project_to_gitosis dirname, gitosis_group, gitosis_file, gitosis_file

      gtss = Git.open ext_gitosis_dir
      gtss.add 'gitosis.conf' 
      gtss.commit '.' 
      gtss.push(gtss.remote( 'origin' ))
      
      g.push(g.remote( remote_name ))
    end

    def get_dirname dir
      file = File.new dir
      path = File.absolute_path file
      path_array = path.split '/'
      dirname = path_array.last
      return dirname
    end
#   - ++ -> 
# * *Returns* :
#   - 
    def remove_git_repo dir = '.'
      FileUtils.rm_rf (File.join(dir,'.git'))      
    end
  end

  class Gitosis
    attr_accessor :ops, :log
    def initialize
      @ops = {}
      @log = Logger.new 'log.txt'
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::INFO
      end
    end

# Add a project to the gitosis security conf file
# * *Args*    :
#   - +project_folder+ -> This is the folder where the new project that you want to add to gitosis is located
#   - +to_group+ -> This is the name of the group that you want to add this project to
#   - +gitosis_read+ -> This is location of the gitosis file you are reading from
#   - +gitosis_write+ -> This is location of the gitosis file you are writing to
# * *Returns* :
#   -  
    def add_project_to_gitosis project_name, to_group, gitosis_read, gitosis_write
      groups = consume_file gitosis_read
      group = groups[to_group]
      raise "Couldn't find group: #{to_group}, in file: #{gitosis_read}." if group.nil? 
      writable = group['writable'].strip
      writable += " " + project_name + "\n"
      group['writable'] = writable
      groups[to_group] = group
      write_gitosis_file gitosis_write, groups
    end

# * *Args*    :
#   - ++ -> 
# * *Returns* :
#   - 
    def remove_project_from_gitosis project_name, from_group, gitosis_read, gitosis_write
      groups = consume_file gitosis_read
      group = groups[from_group]
      raise "Couldn't find group: #{to_group}, in file: #{gitosis_read}." if group.nil? 
      writable = group['writable'].split " "
      writable.delete_at(writable.index(project_name) || li.length)
      group['writable'] = writable.join " "
      group['writable'] += "\n"
      groups[from_group] = group
      write_gitosis_file gitosis_write, groups
    end

# * *Args*    :
#   - ++ -> 
# * *Returns* :
#   - 

    def consume_file (gitosis_file = nil)
      @log.debug "Will try to read file: " + File.absolute_path(gitosis_file)
      groups = {}
      File.open(gitosis_file, "r") do |infile|
        while (line = infile.gets)
          if /^\[group (.*)\]/ =~ line
            group_name = $1
            writable = infile.gets
            members = infile.gets
            group_data = { 'members' => members, 'writable' => writable }
            groups[group_name] = group_data
          end
        end
      end
      return groups
    end
# * *Args*    :
#   - +filename+ -> This will be the filename to write to, if it already exists it will be overwritten
#   - +data+ -> The data to write into the +filename+.  Should be of the form
    # returned by the +consume_file+ command.    
    def write_gitosis_file filename, data
      File.open(filename, 'w'){|f| 
        f.write "[gitosis]\n\n"
        data.each_pair do |group,grp_data|
          members = grp_data['members']
          writable = grp_data['writable']
          f.write "[group #{group}]\n"
          f.write writable
          f.write members + "\n"
        end
      }
    end


# * *Args*    :
#   - +regex+ -> A regular expression.  Should be surrounded by
#   forward slashes '/', for example: /fe(..)on/
#   - +candidate+ -> This is the string for which you want to test to
#   see if the regular expression is in it.  For example: fenton
# * *Returns* :
#   - nil if the regex is not found in the candidate string, otherwise
#   it returns the found regex, in the above example it would return
#   the string nt

    def match_line regex, candidate
      if regex =~ candidate
        return $1
      end
      return nil
    end
  end
end



