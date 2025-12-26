module Cnvrg
  module Helpers

    extend self

    def parallel_threads
      15
    end

    def self.parallel_options
      {
        in_processes: Cnvrg::CLI::ParallelProcesses,
        in_thread: Cnvrg::CLI::ParallelThreads,
        isolation: true
      }
    end

    def checkmark
      return "" if Cnvrg::Helpers.windows?
      checkmark = "\u2713"
      return checkmark.encode('utf-8')
    end

    def internet_connection?
      begin
        true if open("http://www.google.com/")
      rescue
        false
      end
    end

    def try_until_success(tries: 3)
      exception = nil
      tries.times do |i|
        begin
          yield
          return true
        rescue => e
          Cnvrg::Logger.log_info("Error while trying for the #{i} time")
          Cnvrg::Logger.log_error(e)
          sleep(1)
          exception = e
        end
      end
      raise exception
    end

    def get_config
      home_dir = File.expand_path('~')
      config = {}
      begin
        if File.exist? home_dir + "/.cnvrg/config.yml"
          config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
        end
      end
      return config
    end

    def set_config(config)
      home_dir = File.expand_path('~')
      File.open("#{home_dir}/.cnvrg/config.yml", "w") { |f| f.write config.to_yaml }
      return config
    end

    def remote_url
      home_dir = File.expand_path('~')
      config = ""
      begin
        if File.exist? home_dir + "/.cnvrg/config.yml"
          config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
        else
          return "https://app.cnvrg.io"
        end

      rescue
        return "https://app.cnvrg.io"
      end
      if !config or config.empty? or config.to_h[:api].nil?
        return "https://app.cnvrg.io"
      else
        return config.to_h[:api].gsub("/api", "")
      end
    end

    def server_version
      config = self.get_config
      config[:version].try(:to_i) || 0
    end

    def update_version(version)
      config = self.get_config
      if config[:version].to_s.eql? version
        return
      end
      config[:version] = version
      self.set_config(config)
    end

    def is_verify_ssl
      home_dir = File.expand_path('~')
      config = ""
      begin
        if File.exist? home_dir + "/.cnvrg/config.yml"
          config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
        else
          return true

        end

      rescue
        return true
      end
      if !config or config.empty? or config.to_h[:verify_ssl].nil?
        return true
      else
        return config.to_h[:verify_ssl]
      end
    end

    def os

      if windows?
        return "windows"
      elsif mac?
        return "mac"
      elsif ubuntu?
        return "ubuntu"
      elsif linux?

        return "linux"
      else

        return "N/A"
      end
    end

    def windows?
      !!(RUBY_PLATFORM =~ /mswin32|mingw32/)
    end

    def mac?
      !!(RUBY_PLATFORM =~ /-darwin\d/)
    end

    def linux?
      not mac? and not windows?
    end

    def ubuntu?
      unix = `if [ -f  /etc/lsb-release ];  then echo "ubuntu"; fi`
      return unix.include? "ubuntu"
    end

    def cnvrgignore_content
      #TODO: cnvrg ignore add .conflict
      %{
# cnvrg ignore: Ignore the following directories and files
# for example:
# some_dir/
# some_file.txt
.git*
.gitignore
*.conflict
*.deleted
            }.strip
    end

    def hyper_content
      %{# Hyperparameter Optimization is the process of choosing a set of parameters for a learning algorithm, usually with the goal of optimizing a measure of the algorithm's performance on an independent data set.

# Below is the list of parameters that will be used in the optimization process. Each parameter has a param_name that should match the argument that is feeded to the experiment s.t kernel => --kernel='rbf'

parameters:
  # Integer parameter is a range of possible values between a minimum (inclusive)
  # and maximum (not inclusive) values. Values are floored (0.7 => 0)
    - param_name: "learning_rate"
      type: "integer" 
      min: 0 # inclusive
      max: 10 # not inclusive
      scale: "linear"
      steps: 4 # The number of linear steps to produce.


    # Float parameter is a range of possible values between a minimum (inclusive)
    # and maximum (not inclusive) values.
    #
    - param_name: "learning_rate"
      type: "float" # precision is 9 after period
      min: 0.00001
      max: 0.1
      scale: "log2" # Could be log10 as well
      steps: 2

    # Discrete parameter is an array of numerical values.
    #
    - param_name: "c"
      type: "discrete"
      values: [0, 0.1 ,0.001]

    # Categorical parameter is an array of string values
    #
    - param_name: "kernel"
      type: "categorical"
      values: ["linear", "poly", "rbf"] 
    
}
    end

    def readme_content
      %{
            # README

            This README would normally contain some context and description about the project. 

            Things you may want to cover:

            * Data description

            * Benchmark and measurement guidelines

            * Used algorithms

            * Scores

            * Configurations

            * Requirements

            * How to run the experiments

            * ...}.strip
    end

    def netrc_domain
      "cnvrg.io"
    end

    def look_for_in_path(path, name)
      url_split = path.split("/")
      url_split.each_with_index do |u, i|
        if u == name
          return i
        end
      end
      return -1
    end

    def extract_owner_slug_from_url(url, breaker)
      url_parts = url.split("/")
      project_index = Cnvrg::Helpers.look_for_in_path(url, breaker)
      slug = url_parts[project_index + 1]
      owner = url_parts[project_index - 1]
      return owner, slug
    end

    # cpu

    def cpu_time
      Process.clock_gettime(Process::CLOCK_PROCESS_CPUTIME_ID, :microsecond)
    end

    def wall_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
    end

    def decrypt(key, iv, str)
      begin

        cipher = OpenSSL::Cipher.new("aes-256-cbc").decrypt
        cipher.key = key
        cipher.iv = Base64.decode64 iv.encode('utf-8')

        result = Base64.decode64 (str.encode('utf-8'))
        result = cipher.update(result)
        result << cipher.final
        return result.force_encoding('utf-8')

        # return result
      rescue => e
        puts e

      end

    end

    # memory
    #
    def get_mem(pid) end

    def get_s3_props(files)
      #will return client and decryptor
      sts_path = files["path_sts"]
      retries = 0
      success = false
      while !success and retries < 20
        begin
          if !Helpers.is_verify_ssl
            body = open(sts_path, { ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }).read
          else
            body = open(sts_path).read
          end
          success = true
        rescue => e
          retries += 1
          sleep(5)

        end
      end
      if !success
        return Cnvrg::Result.new(false, "couldn't download some files", "error in sts", "")
      end
      split = body.split("\n")
      key = split[0]
      iv = split[1]

      access = Cnvrg::Helpers.decrypt(key, iv, files["sts_a"])

      secret = Cnvrg::Helpers.decrypt(key, iv, files["sts_s"])

      session = Cnvrg::Helpers.decrypt(key, iv, files["sts_st"])
      region = Cnvrg::Helpers.decrypt(key, iv, files["region"])

      bucket = Cnvrg::Helpers.decrypt(key, iv, files["bucket"])
      is_s3 = files["is_s3"]
      server_side_encryption = files["server_side_encryption"]

      if is_s3 or is_s3.nil?
        client = Aws::S3::Client.new(
          :access_key_id => access,
          :secret_access_key => secret,
          :session_token => session,
          :region => region,
          :http_open_timeout => 60, :retry_limit => 20)
        use_accelerate_endpoint = true
      else

        endpoint = Cnvrg::Helpers.decrypt(key, iv, files["endpoint"])
        client = Aws::S3::Client.new(
          :access_key_id => access,
          :secret_access_key => secret,
          :region => region,
          :endpoint => endpoint, :force_path_style => true, :ssl_verify_peer => false,
          :http_open_timeout => 60, :retry_limit => 20)
        use_accelerate_endpoint = false
      end

      if !server_side_encryption
        upload_options = { :use_accelerate_endpoint => use_accelerate_endpoint }
      else
        upload_options = { :use_accelerate_endpoint => use_accelerate_endpoint, :server_side_encryption => server_side_encryption }
      end
      return { client: client, key: key, iv: iv, bucket: bucket, upload_options: upload_options }
    end

    def get_experiment_events_log_from_server(exp, project, commit: nil)
      dest_dir = exp["slug"]
      commit = commit || exp["end_commit"]
      response = project.clone(0, commit)
      Cnvrg::CLI.is_response_success(response, should_exit = false)
      commit_sha1 = response["result"]["commit"]
      files = response["result"]["tree"].keys
      files = files.select do |f|
        f.include?("tfevents")
      end
      @files = Cnvrg::Files.new(project.owner, project.slug, project_home: "", project: project)
      @files.download_files(files, commit_sha1, progress: nil)
      FileUtils.rm_rf("#{dest_dir}")
      FileUtils.mkdir_p(dest_dir)
      num_of_new_files = 0
      files.each do |f|
        file_dir = "#{dest_dir}/#{File.dirname(f)}"
        FileUtils.mkdir_p(file_dir)
        num_of_new_files += 1 unless File.exist?("#{dest_dir}/#{f}")
        FileUtils.mv(f, "#{dest_dir}/#{f}")
      end
      return num_of_new_files
    end

    def get_config_v2_project(dir, owner, slug)
      config = {}
      if File.exist? dir + "/.cnvrg/config.yml"
        config = YAML.load_file(dir + "/.cnvrg/config.yml")
      elsif File.exist? dir + "/.cnvrg/cnvrg.config"
        cnvrgv2_config = YAML.load_file(dir + "/.cnvrg/cnvrg.config")
        config[:project_name] = cnvrgv2_config["project_slug"]
        config[:project_slug] = cnvrgv2_config["project_slug"]
        config[:owner] = ENV['CNVRG_OWNER']
        config[:git] = cnvrgv2_config["git"] || false
      else
        return { owner: owner, project_slug: slug }
      end
      config
    end
    def get_config_v2_dataset(dir)
      config = {}
      if File.exist? dir + "/.cnvrg/config.yml"
        config = YAML.load_file(dir + "/.cnvrg/config.yml")
      elsif File.exist? dir + "/.cnvrg/cnvrg.config"
        cnvrgv2_config = YAML.load_file(dir + "/.cnvrg/cnvrg.config")
        config[:dataset_name] = cnvrgv2_config["dataset_slug"]
        config[:dataset_slug] = cnvrgv2_config["dataset_slug"]
        config[:owner] = ENV['CNVRG_OWNER']
      end
      config
    end
  end
end
