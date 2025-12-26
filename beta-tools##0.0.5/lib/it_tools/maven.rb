require 'xmlsimple'
require_relative 'shared'
require 'logger'

class Maven
  attr_accessor :ops, :pom, :re, :log
  def initialize(xml_string, options = {})
    defaults = { :jar_with_dependencies => false, :debug => true }
    options = defaults.merge(options)
    @ops = options
    @pom = XmlSimple.xml_in xml_string
    @re = SharedTool::RegularExpression.new
    @log = Logger.new 'log.txt'
    if level = @ops[:debug_level]
      @log.level = level
    else
      @log.level = Logger::INFO
    end
    process_pom
  end
  def process_pom
    @ops[:artifactId] = @pom['artifactId'][0]
    @ops[:version] = @pom['version'][0]
    @ops[:prev_version] = get_prev_version @ops[:version]
  end

  def build(options = {})
    defaults = { :jar_with_dependencies => false, :environment_specific => false }
    options = defaults.merge(options)
    @ops = @ops.merge(options)
    build_command = "mvn package"
    if @ops[:jar_with_dependencies]
      build_command = "mvn assembly:assembly"
    end
    if @ops[:env]
      puts "WARNING: You are building an environment specific artifact, use caution."
      profile = get_profile_name(@ops[:env])
      build_command += " -P#{profile}"
    end
    if ops[:dry_run] 
      puts "[would run command]: " + build_command
    else
      system(build_command) 
    end
  end

  def get_profile_name(environment)
    profile = {
      'loc' => 'loc',
      'dev'  => 'dev',
      'stg'  => 'stage',
      'prod' => 'prod'
    }
    return profile[environment]
  end


  def get_artifactId(xml_string)
    artifactId = re.first_occurrence( xml_string, /<artifactId>(.*)<\/artifactId>/)
  end

  def get_packaging(xml_string)
    packaging = re.first_occurrence( xml_string, /<packaging>(.*)<\/packaging>/)
  end

  def get_artifact_name(xml_string)
    artifactId = get_artifactId(xml_string)
    packaging = get_packaging(xml_string)
    if ops[:jar_with_dependencies]
      return artifactId + "-jar-with-dependencies." + packaging
    else
      return artifactId + "." + packaging
    end
  end

  def has_assembly
    plugins = @pom['build']['pluginManagement']['plugins']
    plugins.each do |key,value|
      p key
    end
  end
  def get_built_artifact_name_with_version(xml_string)
    version = @ops[:version]
    prev_ver = get_prev_version(version)
    artifactId = get_artifactId(xml_string)
    packaging = get_packaging(xml_string)
    # puts "Dumping class: " + self.inspect if ops[:debug]

    if ops[:jar_with_dependencies]
      return "#{artifactId}-jar-with-dependencies-#{prev_ver}.#{packaging}"
    else
      return "#{artifactId}-#{prev_ver}.#{packaging}"
    end
  end

  def get_prev_version(curr_version)
    m = /(\d+\.\d+\.)(\d+)/.match(curr_version)
    m[1].to_s + (m[2].to_i - 1).to_s
  end

end
