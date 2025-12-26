require_relative 'options'

class Environment
  attr_accessor :ops
  
  def initialize(options = {})
      defaults = { :jar_with_dependencies => false, :debug => true, :dry_run => false }
      @ops = defaults.merge options
      command_line_opts = Options.new
      @ops = @ops.merge command_line_opts.options
  end
  
  def set_options(options = {})
    @ops = @ops.merge(options)
  end

  def deploy(env, options = {})
    defaults = { :jar_with_dependencies => false }
    options = defaults.merge(options)
    @ops = @ops.merge(options)
    puts self.inspect if ops[:debug]
    cmd = get_deploy_command(env)
    puts "[Command]: " + cmd if ops[:debug]
    unless ops[:dry_run] 
      system(cmd) 
    end
  end

  def get_deploy_command(env,file, options = {})
    @ops = @ops.merge(options)
    dd = get_deploy_dir(env)
    dh = get_hostname(env)
    du = get_deploy_user(env)
    mvn = Maven.new(file, @ops)
    an = mvn.get_artifact_name(file)
    ban = mvn.get_built_artifact_name_with_version(file)
    puts "[Built maven artifact]: " + ban if ops[:debug]
    sc = get_scp_command(an, du, dh, dd, ban)
  end

  def get_scp_command(src_artifact_name, login_as_who, dest_hostname,  dest_dir, dest_artifact_name = nil)
    deploy_cmd = "rsync -avP --stats "
    if @ops[:use_scp]
      deploy_cmd = "scp "
    end
    deploy_cmd += "target/#{src_artifact_name} #{login_as_who}@#{dest_hostname}:#{dest_dir}"
    if dest_dir
      deploy_cmd += "/#{dest_artifact_name}"
    end
    return deploy_cmd;
  end

  def get_solr_base_url(env)
    solr_base_url = {
      'loc' => 'http://localhost:8983/solr/'
    }
    return solr_base_url[env]
  end
  def get_deploy_dir(environment)
    user = {
      'dev'  => '/scratch/ngsp/hrmsToCrmod',
      'stg'  => '/u02/webapps/myhelp/custom',
      'prod' => '/u01/app/oracle/ngsp/wls4/user_projects/domains/base_domain2/deployments'
    }
    return user[environment];
  end
  def get_deploy_user(environment)
    f = 'ftravers'
    user = {
      'dev'  => f,
      'stg'  => 'oracle',
      'prod' => f
    }
    return user[environment];
  end
  def get_hostname(environment)
    domain = ".us.oracle.com"
    hosts = {
      'loc'  => 'localhost',
      'dev'  => 'sta00418' + domain,
      'stg'  => 'wd1125' + domain,
      'prod' => 'amtv1062' + domain
    }
    return hosts[environment]
  end
end # class
