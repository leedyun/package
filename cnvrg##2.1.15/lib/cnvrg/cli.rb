#!/usr/bin/env ruby
require "pty" unless !!(RUBY_PLATFORM =~ /mswin32|mingw32/)
require 'etc'
require 'parallel'
require 'netrc'
require 'net/http'
require 'uri'
require 'open-uri'
require 'json'
require 'yaml'
require 'digest' # sha1up
require "highline/import"
require 'socket'
require 'thor'
require 'socket'
require 'timeout'
require 'fileutils'
require 'active_support/all'
require 'pathname'
require 'enumerator'
require 'ruby-progressbar'
require 'open3'
require 'logstash-logger'
require 'cnvrg/helpers'
require 'cnvrg/api'
require 'cnvrg/auth'
require 'cnvrg/project'
require 'cnvrg/files'
require 'cnvrg/experiment'
require 'cnvrg/image'
require 'cnvrg/dataset'
require 'cnvrg/datafiles'
require 'cnvrg/data'
require 'cnvrg/storage'
require 'cnvrg/result'
require 'cnvrg/logger'
require 'cnvrg/org_helpers'
require 'cnvrg/cli/subcommand'
require 'cnvrg/cli/flow'
require 'cnvrg/cli/task'
require 'cnvrg/cli/library_cli'
require 'cnvrg/image_cli'
require 'cnvrg/helpers/executer'
require 'cnvrg/downloader/client'
require 'cnvrg/downloader/clients/s3_client'
require 'cnvrg/downloader/clients/gcp_client'
require 'cnvrg/downloader/clients/azure_client'
require 'cnvrg/job_cli'
require 'cnvrg/job_ssh'
require 'cnvrg/connect_job_ssh'
require 'cnvrg/api_v2'
require 'rubygems/package'

class Thor
  module Base
    def initialize(args = [], local_options = {}, config = {})
      parse_options = Thor.class_options

      # The start method splits inbound arguments at the first argument
      # that looks like an option (starts with - or --). It then calls
      # new, passing in the two halves of the arguments Array as the
      # first two parameters.

      command_options = config.delete(:command_options) # hook for start
      parse_options = parse_options.merge(command_options) if command_options
      if local_options.is_a?(Array)
        array_options = local_options
        hash_options = {}
      else
        # Handle the case where the class was explicitly instantiated
        # with pre-parsed options.
        array_options = []
        hash_options = local_options

      end


      # Let Thor::Options parse the options first, so it can remove
      # declared options from the array. This will leave us with
      # a list of arguments that weren't declared.
      stop_on_unknown = Thor.stop_on_unknown_option? config[:current_command]
      opts = Thor::Options.new(parse_options, hash_options, stop_on_unknown)
      real_options = []
      real_args = [].replace(array_options)
      if local_options.is_a? (Array) and !local_options.empty? and args.empty?
        array_options.each_with_index do |p, i|
          opt = p
          if p.include? "="
            opt = p.split("=")[0]
          end
          option = is_option(parse_options.values, opt)
          if !option
            break
          else
            real_options << p
            real_args.delete(p)
            if !p.include? "=" and option.type != :boolean
              if i + 1 < array_options.size
                real_options << array_options[i + 1]
                real_args.delete(array_options[i + 1])
              end
            end

          end

        end

        args = real_args
      else
        if !args.empty? and local_options.is_a? Array and !local_options.empty?
          args = args + local_options
        else
          args = args.flatten()
        end

      end


      self.options = opts.parse(real_options)
      self.options = config[:class_options].merge(options) if config[:class_options]

      # If unknown options are disallowed, make sure that none of the
      # remaining arguments looks like an option.
      opts.check_unknown! if Thor.check_unknown_options?(config)

      # Add the remaining arguments from the options parser to the
      # arguments passed in to initialize. Then remove any positional
      # arguments declared using #argument (this is primarily used
      # by Thor::Group). Tis will leave us with the remaining
      # positional arguments.
      to_parse = args
      to_parse += opts.remaining unless self.class.strict_args_position?(config)
      thor_args = Thor::Arguments.new(self.class.arguments)
      thor_args.parse(to_parse).each {|k, v| __send__("#{k}=", v)}
      @args = thor_args.remaining
    end

    def is_option (options, p)
      options.each do |o|
        if !o.aliases.nil?
          if (o.aliases.is_a? Array and o.aliases.include? p) or (o.aliases.is_a? Array and o.aliases.size == 1 and o.aliases[0].split(",").include? p) or o.switch_name.eql? p
            return o
          end
        end

      end
      return false
    end

  end
end


module Cnvrg

  class CLI < Thor

    INSTALLATION_URLS = {docker: "https://docs.docker.com/engine/installation/", jupyter: "http://jupyter.readthedocs.io/en/latest/install.html"}
    IP = "localhost"
    PORT = 7654

    ParallelThreads ||= Cnvrg::Helpers.parallel_threads
    ParallelProcesses ||= Parallel.processor_count

    class << self
      # Hackery.Take the run method away from Thor so that we can redefine it.

      def is_thor_reserved_word?(word, type)
        return false if word == "run"
        super
      end
    end
    desc "data [COMMAND]", "Upload and manage datasets", :hide => false
    subcommand "data", Data

    desc "job", "manage running jobs", :hide => true
    subcommand "job", JobCli

    desc "ssh", "ssh into running jobs", :hide => false
    subcommand "ssh", JobSsh

    desc "image [COMMAND]", "build existing images", :hide => true
    subcommand "image", ImageCli

    desc "library [COMMAND]", "Upload and manage datasets", :hide => false
    subcommand "library", LibraryCli


    desc "flow", "mange project flows", :hide => true
    subcommand "flow", Cnvrg::Commands::Flow


    def initialize(*args)
      super
      self.log_handler
    end

    desc 'version', 'Prints cnvrg current version'

    def version
      puts Cnvrg::VERSION

    end


    desc 'dataurl', 'dataur', :hide => true
    def set_data_url(dataset_url)
      begin
      verify_logged_in(true)
      log_start(__method__, args, options)
      unless is_cnvrg_dir
        log_message("Not in cnvrg dir.", Thor::Shell::Color::RED)
      end
      url_parts = dataset_url.split("/")
      project_index = Cnvrg::Helpers.look_for_in_path(dataset_url, "datasets")
      slug = url_parts[project_index + 1]
      owner = url_parts[project_index - 1]
      res = Cnvrg::API.request("users/#{owner}/datasets/#{slug}", 'GET')
      unless Cnvrg::CLI.is_response_success(res, false)
        raise SignalException.new
      end
      @dataset = Dataset.new(Dir.pwd)
      result = res['result']
      @dataset.change_url(result.symbolize_keys)
      log_message("Changed URL Succesfuly to #{dataset_url}", Thor::Shell::Color::GREEN)
      rescue => e
        log_message("Cant change the url to the given dataset url", Thor::Shell::Color::RED)
      end
    end

    map %w(-v --version) => :version

    desc 'api CNVRG_APPLICATION_URL', 'Set api url, e.g cnvrg --api "https://cnvrg.io/api"'
    method_option :verify_ssl, :type => :boolean, :aliases => ["-s", "--verify_ssl"], :default => false

    def set_api_url(url)
      log_handler()
      log_start(__method__, args, options)
      home_dir = File.expand_path('~')
      if url.end_with? "/"
        url = url.chomp("/")
      end
      if !url.end_with? "/api"
        url = url + "/api"
      end
      verify_ssl = options["verify_ssl"] || false
      begin
        if !File.directory? home_dir + "/.cnvrg"
          FileUtils.mkdir_p([home_dir + "/.cnvrg", home_dir + "/.cnvrg/tmp"])
        end
        if !File.exist?(home_dir + "/.cnvrg/config.yml")
          FileUtils.touch [home_dir + "/.cnvrg/config.yml"]
        end
        compression_path = "#{File.expand_path('~')}/.cnvrg/tmp"
        begin
          config = YAML.load_file(home_dir+"/.cnvrg/config.yml")
          if !config
            config = {owner: "", username: "", version_last_check: get_start_day(), api: url, compression_path: compression_path ,verify_ssl: verify_ssl }
          end



        rescue
          config = {owner: "", username: "", version_last_check: get_start_day(), api: url, compression_path: compression_path ,verify_ssl: verify_ssl }
        end

        say "Setting default api to be: #{url}", Thor::Shell::Color::BLUE
        if config.empty?
          config = {owner: "", username: "", version_last_check: get_start_day(), api: url, compression_path: compression_path, verify_ssl: verify_ssl }
        else
          if !config.to_h[:compression_path].nil?
            compression_path = config.to_h[:compression_path]
          end
          config = {owner: config.to_h[:owner], username: config.to_h[:username], version_last_check: config.to_h[:version_last_check], api: url, compression_path: compression_path, verify_ssl: verify_ssl}
        end

        checks = Helpers.checkmark
        File.open(home_dir+"/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }

        say "#{checks} Done", Thor::Shell::Color::GREEN

      rescue => e
        log_error(e)
        say "Couldn't set default api, contact help@cnvrg.io", Thor::Shell::Color::RED
      end
    end

    desc '', '', :hide => true

    def set_remote_login(current_user, owner, url, email, secret)
      netrc = Netrc.read
      netrc[Cnvrg::Helpers.netrc_domain] = email, secret
      netrc.save
      home_dir = File.expand_path('~')
      if !url.end_with? "/api"
        url = url + "/api"
      end
      begin
        if !File.directory? home_dir + "/.cnvrg"
          FileUtils.mkdir_p([home_dir + "/.cnvrg", home_dir + "/.cnvrg/tmp"])
        end
        if !File.exist?(home_dir + "/.cnvrg/config.yml")
          FileUtils.touch [home_dir + "/.cnvrg/config.yml"]
        end
        config = YAML.load_file(home_dir + "/.cnvrg/config.yml")

        compression_path = "#{home_dir}/.cnvrg/tmp"
        config = {owner: owner, username: current_user, version_last_check: get_start_day(), api: url, compression_path: compression_path}
        File.open(home_dir + "/.cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
        say "Done", Thor::Shell::Color::GREEN
      rescue
        say "ERROR", Thor::Shell::Color::RED
          File.open(home_dir+"/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
          say "#{checks} Done", Thor::Shell::Color::GREEN
        # else
        #   say "Couldn't set default api, contact help@cnvrg.io", Thor::Shell::Color::RED
        #   exit(1)
        #
        # end

      rescue => e
        say "Couldn't set default api, contact help@cnvrg.io", Thor::Shell::Color::RED
      end
    end

    desc '', '', :hide => true

    def set_remote_api_url(owner, current_user, url)
      home_dir = File.expand_path('~')
      if !url.end_with? "/api"
        url = url + "/api"
      end
      begin
        if !File.directory? home_dir + "/.cnvrg"
          FileUtils.mkdir_p([home_dir + "/.cnvrg", home_dir + "/.cnvrg/tmp"])
        end
        if !File.exist?(home_dir + "/.cnvrg/config.yml")
          FileUtils.touch [home_dir + "/.cnvrg/config.yml"]
        end
        config = YAML.load_file(home_dir + "/.cnvrg/config.yml")

        compression_path = "#{home_dir}/.cnvrg/tmp"
        config = {owner: owner, username: current_user, version_last_check: get_start_day(), api: url, compression_path: compression_path}
        File.open(home_dir + "/.cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
        say "Done", Thor::Shell::Color::GREEN
      rescue
        say "ERROR", Thor::Shell::Color::RED
      end
    end

    map %w(api -api --api) => :set_api_url

    desc 'set_default_owner', 'Set default owner'

    def set_default_owner
      begin
        path = File.expand_path('~') + "/.cnvrg/config.yml"
        if !File.exist?(path)
          say "Couldn't find ~/.cnvrg/config.yml file, please logout and login again", Thor::Shell::Color::RED

          exit(0)
        end
        config = YAML.load_file(path)

        username = config.to_h[:username]
        res = Cnvrg::API.request("/api/v1/users/#{username}/get_possible_owners", 'GET')
        if Cnvrg::CLI.is_response_success(res)
          owner = username
          result = res["result"]
          owners = result["owners"]
          urls = result["urls"]
          choose_owner = result["username"]
          if owners.empty?
          else
            chosen = false
            while !chosen
              owners_id = owners.each_with_index.map {|x, i| "#{i + 1}. #{x}"}
              choose_owner = ask("Choose default owner:\n" + owners_id.join("\n") + "\n")

              if choose_owner =~ /[[:digit:]]/
                ow_index = choose_owner.to_i - 1
                if ow_index < 0 or ow_index >= owners.size
                  say "No such owner, please choose again", Thor::Shell::Color::BLUE
                  chosen = false
                  next
                end
                choose_owner = owners[choose_owner.to_i - 1]
                chosen = true

              else

                owners_lower = owners.map {|o| o.downcase}
                ow_index = owners_lower.index(choose_owner.downcase)
                if ow_index.nil?
                  say "Could not find owner named #{choose_owner}", Thor::Shell::Color::RED
                else
                  chosen = true
                end
              end

            end


          end
          if set_owner(choose_owner, result["username"])
            say "Setting default owner: #{choose_owner}", Thor::Shell::Color::GREEN
          else
            say "Setting default owenr has failed, try to run cnvrg --config-default-owner", Thor::Shell::Color::RED
          end
        end
      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'set_compression_path', 'Set compression path', :hide => true
    method_option :reset, :type => :boolean, :aliases => ["-r", "--reset"], :default => false

    def set_compression_path(*compression_path)
      begin
        if (compression_path.nil? or compression_path.empty?) and options["reset"]
          compression_path = ["#{File.expand_path('~')}/.cnvrg/tmp"]
        end
        compression_path = compression_path.join(" ")
        if !Dir.exist? compression_path
          say "Couldn't find #{compression_path}, please make sure it exist", Thor::Shell::Color::RED
          exit(0)
        end

        home_dir = File.expand_path('~')
        path = "#{home_dir}/.cnvrg/config.yml"
        if !File.exist?(path)
          say "Couldn't find ~/.cnvrg/config.yml file, please logout and login again", Thor::Shell::Color::RED

          exit(0)
        end
        config = YAML.load_file(path)
        config_new = {owner: config.to_h[:owner], username: config.to_h[:username],
                      version_last_check: config.to_h[:version_last_check], api: config.to_h[:api], compression_path: compression_path}
        File.open(home_dir + "/.cnvrg/config.yml", "w+") {|f| f.write config_new.to_yaml}
        checks = Helpers.checkmark
        say "#{checks} Done", Thor::Shell::Color::GREEN

      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end


    desc 'auth', "hidden..", hide: true
    def auth
      token = ENV['CNVRG_TOKEN'] || exit(1)
      owner = ENV['CNVRG_OWNER'] || exit(1)
      user = ENV['CNVRG_USER'] || exit(1)
      api = ENV['CNVRG_API'] || exit(1)
      email = ENV['CNVRG_EMAIL'] || exit(1)

      netrc = Netrc.read
      netrc[Cnvrg::Helpers.netrc_domain] = email, token
      netrc.save

      set_owner(owner, user, api)
    end

    desc 'check_spot', "hidden..", hide: true
    def check_spot
      log_start(__method__, args, options)
      project_home = get_project_home
      @project = Project.new(project_home)

      log_message('Checking Spot Instance Status', Thor::Shell::Color::YELLOW)
      will_terminate = @project.spot_will_terminate
      if not will_terminate
        log_message("Not spot termination detected", Thor::Shell::Color::YELLOW)
        return
      end
      job_type, job_id = ENV['CNVRG_JOB_TYPE'], ENV['CNVRG_JOB_ID']
      machine_activity = @project.get_machine_activity

      notify_thread = Thread.new do
        res = @project.send_restart_request(job_type: job_type, job_id: job_id, ma_id: machine_activity)
        while res.blank?
          res = @project.send_restart_request(job_type: job_type, job_id: job_id, ma_id: machine_activity)
          sleep(10)
        end
      end

      sync_force = job_type == "NotebookSession" ? false : true
      upload(false, false, true, '', true, sync_force , ENV['CNVRG_OUTPUT_DIR'], job_type, job_id)
      log_message('Spot instance is going to be terminated', Thor::Shell::Color::YELLOW)
      notify_thread.join
    end


    desc 'login', 'Authenticate with cnvrg.io platform'
    method_option :sso, :type => :boolean, :aliases => ["-s", "--sso"], :default => false

    def login
      use_token = options["sso"]
      begin
        log_handler()
        log_start(__method__, args, options)

        cmd = HighLine.new

        say 'Authenticating with cnvrg', Thor::Shell::Color::YELLOW

        @auth = Cnvrg::Auth.new
        netrc = Netrc.read
        @email, token = netrc[Cnvrg::Helpers.netrc_domain]

        if @email and token
          log_message('Seems you\'re already logged in', Thor::Shell::Color::BLUE)
          exit(0)
        end
        @email = ask("Enter your email:")
        url = Cnvrg::API.endpoint_uri()
        use_token = true if url.include?("cloud.cnvrg.io")
        if use_token
          @token = cmd.ask("Enter your token (hidden):") {|q| q.echo = "*"}
          netrc[Cnvrg::Helpers.netrc_domain] = @email, @token
          netrc.save
          password = ""
        else
          password = cmd.ask("Enter your password (hidden):") {|q| q.echo = "*"}
        end
        result = @auth.sign_in(@email, password, token: @token)

        if !result["token"].nil?
          unless use_token
            netrc[Cnvrg::Helpers.netrc_domain] = @email, result["token"]
            netrc.save
          end

          log_message("Authenticated successfully as #{@email}", Thor::Shell::Color::GREEN)

          owners = result["owners"]
          choose_owner = result["username"]
          if owners.empty?
            choose_owner = result["username"]
          else
            choose_owner = owners[0]
          end

          if set_owner(choose_owner, result["username"])
            log_message("Setting default owner: #{choose_owner}", Thor::Shell::Color::GREEN)

          else
            log_message("Setting default owenr has failed, logging out", Thor::Shell::Color::RED)

            return logout()
          end

        else
          log_message("Failed to authenticate, wrong email/password", Thor::Shell::Color::RED)

          exit(1)
        end
      rescue => e

        log_message("Error Occurred, aborting", Thor::Shell::Color::RED)
        log_error(e)

        logout()
        exit(1)
      rescue SignalException

        say "\nAborting",Thor::Shell::Color::RED
        logout()
        exit(1)
      end
    end


    desc 'logout', 'Logout existing user'

    def logout
      begin
        log_handler()
        log_start(__method__, args, options)
        netrc = Netrc.read
        netrc.delete(Cnvrg::Helpers.netrc_domain)
        netrc.save
        log_message("Logged out successfully.\n", Thor::Shell::Color::GREEN)
      rescue => e
        puts e.message
        puts e.backtrace
      rescue SignalException
        say "\nAborting",Thor::Shell::Color::RED
        exit(1)
      end

    end


    desc 'me', 'Prints the current logged in user email'

    def me()
      begin

        home_dir = File.expand_path('~')
        config = YAML.load_file(home_dir+"/.cnvrg/config.yml")

        api = config[:api]
        verify_ssl = config[:verify_ssl]
        if api.present?
          log_message("API: #{api}", Thor::Shell::Color::BLUE)
        end
        if verify_ssl.present?
          log_message("SSL Verification: #{verify_ssl}", Thor::Shell::Color::BLUE)
        end
        log_message("Logs file located at: #{$LOG.device.io.path}", Thor::Shell::Color::BLUE)

        verify_logged_in(false)
        log_start(__method__, args, options)
        auth = Cnvrg::Auth.new
        if (email = auth.get_email)
          log_message("Logged in as: #{email}", Thor::Shell::Color::GREEN)
        else
          log_message("You're not logged in.", Thor::Shell::Color::RED)
        end


      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'logs', 'Prints cnvrg cli logs file to screen'
    method_option :lines, :type => :numeric, :aliases => ["-l","-n","--lines"], :default => nil
    def logs()
      begin
        lines = options["lines"]
        if lines.present?
          puts open($LOG.device.io.path).readlines.last(lines)
        else
          puts open($LOG.device.io.path).readlines.last(100)
        end


      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end


    ## Projects
    desc 'new', 'Create a new cnvrg project'
    method_option :clean, :type => :boolean, :aliases => ["-c"], :default => false
    method_option :docker_image, :type => :string, :aliases => ["-d"], :default => ""
    method_option :bucket, :type => :string, :aliases => ["-b", "--bucket"], :default => ""

    def new(project_name)
      begin
       verify_logged_in(false)
        log_start(__method__, args, options)
        clean = options["clean"]
        bucket = options["bucket"]
        docker_image = options["docker_image"]
        working_dir = Dir.pwd + "/" + project_name
        docker = false
        if !docker_image.nil? and !docker_image.empty?
          docker = true
        end
        log_message("Creating #{project_name}", Thor::Shell::Color::BLUE)
        if Dir.exists? project_name or File.exists? project_name
          log_message("Conflict with dir/file #{project_name}", Thor::Shell::Color::RED)
          exit(1)

        end
        if Project.create(project_name, clean, with_docker=docker)
	       path = Dir.pwd + "/" + project_name
          @project = Project.new(path)
          @project.generate_idx
        else
          log_message("Error creating project, please contact support.", Thor::Shell::Color::RED)
          @project.revert(working_dir)

          exit(0)
        end

        log_message("created project successfully", Thor::Shell::Color::GREEN)
        log_message("Linked directory to\t#{@project.url}", Thor::Shell::Color::GREEN)
      rescue => e
        log_message("Error occurred, aborting", Thor::Shell::Color::RED)
        log_error(e)
        if Dir.exist? working_dir

          @project.revert(working_dir)
        end

        exit(1)

      rescue SignalException
        log_end(-1)
        if Dir.exist? working_dir

          @project.revert(working_dir)
        end
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end


    desc 'link', 'Link current directory to a new cnvrg project'
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :docker_image, :type => :string, :aliases => ["-d"], :default => ""
    method_option :git, :type => :boolean, :aliases => ["-g","--git"], :default => false
    method_option :bucket, :type => :string, :aliases => ["-b","--bucket"], :default => ''
    method_option :title, :type => :string, :aliases => ["-t","--title"], :default => nil

    def link
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        docker_image = options["docker_image"]
        bucket = options["bucket"]
        if docker_image.present?
          docker = true
        else
          docker = false
        end

        sync = options["sync"]
        git = options["git"] ||  false
        project_name = options['title']
        project_name ||= File.basename(Dir.getwd)
        log_message("Linking #{project_name}", Thor::Shell::Color::BLUE)
        if File.directory?(Dir.getwd + "/.cnvrg")
          config = YAML.load_file("#{Dir.getwd}/.cnvrg/config.yml")
          log_message("Directory is already linked to #{config[:project_slug]}", Thor::Shell::Color::RED)
          exit(0)
        end
        working_dir = Dir.getwd
        owner = CLI.get_owner
        if Project.link(owner, project_name, docker,git, bucket: bucket)
          path = Dir.pwd
          @project = Project.new(path)
          if sync
            @project.generate_idx() #DEV-741
            log_message("Syncing project", Thor::Shell::Color::BLUE)
            upload(true)
          end

          url = @project.url
          check = Helpers.checkmark
          log_message("#{check} Link finished successfully", Thor::Shell::Color::GREEN)
          log_message("#{project_name}'s location is: #{url}\n", Thor::Shell::Color::GREEN)

        else
          @project.revert(working_dir) unless @project.nil?
          log_message("Error linking project, please contact support.", Thor::Shell::Color::RED)
          exit(0)
        end
      rescue => e
        log_error(e)
      rescue SignalException

        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data init', 'Init dataset directory', :hide => true
    method_option :public, :type => :boolean, :aliases => ["-p", "--public"], :default => false

    def init_data(public, bucket: nil, title: nil)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        dataset_name = File.basename(Dir.getwd)
        if title.present?
          dataset_name = title
        end
        if File.directory?(Dir.getwd + "/.cnvrg")
          config = YAML.load_file("#{Dir.getwd}/.cnvrg/config.yml")
          log_message("Directory is already linked to #{config[:dataset_slug]}", Thor::Shell::Color::RED)

          exit(0)
        end
        log_message("Init dataset: #{dataset_name}", Thor::Shell::Color::BLUE)

        working_dir = Dir.getwd
        owner = CLI.get_owner
        if Dataset.init(owner, dataset_name, options["public"], bucket: bucket)
          path = Dir.pwd
          @dataset = Dataset.new(path)

          url = @dataset.url
          check = Helpers.checkmark
          log_message("#{check} Link finished successfully", Thor::Shell::Color::GREEN)
          log_message("#{dataset_name}'s location is: #{url}\n", Thor::Shell::Color::GREEN)

        else
          @dataset.revert(working_dir) unless @dataset.nil?
          log_message("Error creating dataset, please contact support.", Thor::Shell::Color::RED)
          exit(0)
        end
      rescue => e
        log_error(e)
      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data delete', 'delete dataset', :hide => true
    def delete_data(dataset_slug)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
          owner = CLI.get_owner
        response = Dataset.delete(dataset_slug, owner)

        if Cnvrg::CLI.is_response_success(response)
          log_message("Successfully deleted dataset: #{dataset_slug}", Thor::Shell::Color::GREEN)
        else
          log_message("Error while tying to delete dataset: #{response["messages"]}", Thor::Shell::Color::RED)


        end

      rescue => e
        log_error(e)
      rescue SignalException

        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data verify', 'Verify datasets', :hide => true
    method_option :timeout, :type => :numeric, :aliases => ["-t", "--timeout"], :desc => "Time to wait before returning final answer", :default => nil

    def verify_datasets(dataset_titles, timeout=nil)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        log_message("Verifying datasets #{dataset_titles}", Thor::Shell::Color::BLUE)
        verified = Dataset.verify_datasets(dataset_titles, timeout)
        log_message("All datasets are verified", Thor::Shell::Color::BLUE) if verified
        log_message("Failed to verify datasets", Thor::Shell::Color::RED) if !verified
        exit(1) if !verified
      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data scan', 'Lookup datasets', :hide => true
    def scan_datasets()
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        log_message("Scanning datasets", Thor::Shell::Color::BLUE)
        datasets = Dataset.scan_datasets()
        puts(datasets.to_json)
      end
    end

    desc 'data clone', 'Clone dataset', :hide => true
    method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :default => ""
    method_option :only_tree, :type => :boolean, :aliases => ["-t", "--tree"], :default => false
    method_option :query, :type => :string, :aliases => ["-q", "--query"], :default => nil
    method_option :read, :type => :boolean, :aliases => ["-r", "--read"], :default => false
    method_option :remote, :type => :boolean, :aliases => ["-h", "--remote"], :default => false
    method_option :soft, :type => :boolean, :aliases => ["-s", "--soft"], :default => false, :hide => true
    def clone_data(dataset_url, only_tree=false, commit=nil, query=nil, read=false, remote=false, flatten: false, relative: false, soft: false, threads: 15, cache_link: false)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        commit = options["commit"] || commit
        only_tree = options["only_tree"] || only_tree
        read = options["read"] || read || false
        remote = options["remote"] || remote || false
        query = options['query'].presence || query.presence
        soft = options['soft'] || soft
        if query.present?
          return clone_data_query(dataset_url, query, flatten, soft: soft)
        end

        url_parts = dataset_url.split("/")
        project_index = Cnvrg::Helpers.look_for_in_path(dataset_url, "datasets")
        slug = url_parts[project_index + 1]
        owner = url_parts[project_index - 1]
        @dataset = Dataset.new(dataset_url: dataset_url)
        response = {}
        response["result"] = @dataset.get_dataset(commit: commit, query: query)
        dataset_name = response["result"]["name"]
        dataset_home = Dir.pwd+"/"+dataset_name

        Dataset.stop_if_dataset_present(dataset_home, dataset_name, commit: response["result"]["commit"]) if soft

        check = Helpers.checkmark
        if @dataset.init_home(remote:remote)
          log_message("Cloning #{dataset_name}", Thor::Shell::Color::BLUE)
          @files = Cnvrg::Datafiles.new(owner, slug, dataset: @dataset)
          log_message("Downloading files", Thor::Shell::Color::BLUE)
          if @dataset.softlinked?
            @files.cp_ds(relative: relative)
            log_message("#{check} Clone finished successfully", Thor::Shell::Color::GREEN)
            @dataset.write_success
            return
          end


          if only_tree
            Dataset.clone_tree(commit: commit, dataset_home: dataset_home)
            return
          end

          commit = response["result"]["commit"]
          files_count = response["result"]["file_count"]
          files = @files.get_clone_chunk(commit: commit, cache_link: cache_link)
          downloaded_files = 0
          progressbar = ProgressBar.create(:title => "Download Progress",
                                           :progress_mark => '=',
                                           :format => "%b>>%i| %p%% %t",
                                           :starting_at => 0,
                                           :total => files_count,
                                           :autofinish => true)

          Dataset.clone_tree(commit: commit, dataset_home: dataset_home, progressbar: progressbar)

          while files['keys'].length > 0
            Cnvrg::Logger.log_info("download multiple files, #{downloaded_files.size} files downloaded")
            @files.download_multiple_files_s3(files, @dataset.local_path, progressbar: progressbar, read_only: read, flatten: flatten, threads: threads, cache_link: cache_link)

            downloaded_files += files['keys'].length
            files = @files.get_clone_chunk(commit: commit, latest_id: files['latest'])
          end
          progressbar.finish
          if downloaded_files == files_count
            Dataset.verify_cnvrgignore_exist(dataset_name, false)
            log_message("#{check} Clone finished successfully", Thor::Shell::Color::GREEN)
            @dataset.write_success
            ### if read, dont generate idx (but create idx.yml) if not read, generate idx.
            # TODO fix it for later... (check it in different cases)
            @dataset.write_idx(read ? {} : nil, commit) #nil means, generate idx
          end
        else
          log_message("Error: Couldn't create directory: #{dataset_name}", Thor::Shell::Color::RED)
          exit(1)
        end
      rescue Interrupt
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data clone_query', 'Clone dataset _query', :hide => true
    method_option :query, :type => :string, :aliases => ["-q", "--query"], :default => ""
    method_option :soft, :type => :boolean, :aliases => ["-s", "--soft"], :default => false, :hide => true
    def clone_data_query(dataset_url, query=nil, flatten=false, soft: false)
      begin
        verify_logged_in(false)
        #@executer = Cnvrg::Helpers::Executer.get_executer
        log_start(__method__, args, options)
        query = options["query"] || query
        soft = options["soft"] || soft
        if !query.present?
          log_message("Argument missing : query", Thor::Shell::Color::RED)
          exit(1)
        end

        url_parts = dataset_url.split("/")
        project_index = Cnvrg::Helpers.look_for_in_path(dataset_url, "datasets")
        slug = url_parts[project_index + 1]
        owner = url_parts[project_index - 1]
        response = Cnvrg::API.request("users/#{owner}/datasets/#{slug}/search/#{query}", 'GET')
        Cnvrg::CLI.is_response_success(response,true)
        dataset_name = response["results"]["name"]
        dataset_slug = response["results"]["slug"]
        dataset_home = Dir.pwd + "/" + dataset_slug
        Dataset.stop_if_dataset_present(dataset_home, dataset_name) if soft

        if Dataset.blank_clone(owner, dataset_name, dataset_slug)
          dataset = Dataset.new(dataset_home)
          downloader = dataset.get_storage_client
          log_message("Cloning #{dataset_name}", Thor::Shell::Color::BLUE)
          parallel_options = {
              :progress => {
                  :title => "Download Progress",
                  :progress_mark => '=',
                  :format => "%b>>%i| %p%% %t",
                  :starting_at => 0,
                  :total => response["results"]["query_files"].size,
                  :autofinish => true
              },
              in_threads: ParallelThreads
          }

          begin
            log_message("Downloading files", Thor::Shell::Color::BLUE)
            Parallel.map((response["results"]["query_files"]), parallel_options) do |f|
              relative_path = f["fullpath"].gsub(/^#{dataset_home}/, "").gsub(/^#{slug}/, "")
              relative_path_dir = relative_path.split("/")
              file_name = relative_path_dir.pop()
              relative_path_dir = relative_path_dir.join("/")
              abs_path = dataset_home + "/" + relative_path_dir
              abs_path = dataset_home if flatten
              fullpath = abs_path + "/" + file_name
              fullpath = fullpath.gsub("//", "/")

              begin
                FileUtils.mkdir_p(abs_path) unless File.exist? (fullpath)
              rescue
                log_message("Could not create directory: #{abs_path}", Thor::Shell::Color::RED)
                exit(1)
              end
              begin
                unless File.exist?(fullpath)
                  downloader.safe_operation("#{abs_path}/#{file_name}") do
                    download = open(f["url"],{ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
                    IO.copy_stream(download, fullpath)
                  end
                end
              rescue => e
                log_message("Could not download file: #{f["fullpath"]}", Thor::Shell::Color::RED)
                exit(1)
              end
            end
            #@executer.set_dataset_status(dataset: dataset.slug, status: "cloned") if @executer.present?
          rescue Interrupt
            log_message("Couldn't download", Thor::Shell::Color::RED)
            exit(1)
          end
          begin
            dataset.generate_idx()
            check = Helpers.checkmark
            log_message("#{check} Clone finished successfully", Thor::Shell::Color::GREEN)
            dataset.write_success(in_folder=true)
          rescue => e
              exit(1)
          end
        end
      rescue SignalException
        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data_snap', 'Init dataset directory', :hide => true
    method_option :public, :type => :boolean, :aliases => ["-p", "--public"], :default => false

    def snap_data
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)

        owner = CLI.get_owner
        path = Dir.pwd
        @dataset = Dataset.new(path)

        log_end(0)

      rescue SignalException
        log_end(-1)

        say "\nAborting", Thor::Shell::Color::RED
        exit(1)
      end
    end

    desc 'data_snap', 'Init dataset directory', :hide => true

    def data_init_container(owner, dataset_slug, dataset_name)

      if Dataset.init_container(owner, dataset_slug, dataset_name)

        say "init finished successfully", Thor::Shell::Color::GREEN

      else
        say "error creating dataset, please contact support.", Thor::Shell::Color::RED
        exit(0)
      end
    end

    desc 'data download', 'pull data', :hide => true
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false

    def download_data(verbose, sync, path = Dir.pwd, in_dir = true)
      begin
        verify_logged_in(in_dir)
        log_start(__method__, args, options)
        if path.nil? or path.empty?
          path = Dir.pwd
        end
        dataset_dir = is_cnvrg_dir(path)
        @dataset = Dataset.new(dataset_dir)

        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug)
        new_branch = options["new_branch"] || false

        res = @dataset.compare_idx(new_branch)["result"]

        result = res["tree"]

        commit = res["commit"]
        if result["updated_on_server"].empty? and result["conflicts"].empty? and result["deleted"].empty?
          log_message("Project is up to date", Thor::Shell::Color::GREEN, ((options["sync"] or sync)) ? false : true)
          return true
        end
        log_message("Downloading data", Thor::Shell::Color::BLUE)

        result = @dataset.downlowd_updated_data(@dataset.last_local_commit)

        delete = result["result"]["delete"]
        commits = result["result"]["commits"]
        updated_idx = result["result"]["idx"]
        parallel_options = {
            :progress => {
                :title => "Download Progress",
                :progress_mark => '=',
                :format => "%b>>%i| %p%% %t",
                :starting_at => 0,
                :total => commits.size,
                :autofinish => true
            },
            in_processes: ParallelProcesses,
            in_thread: ParallelThreads
        }

        begin
          tar_files = []
          download_result = Parallel.map(commits, parallel_options) do |c|

            file_name = @files.download_data_file(c, dataset_dir)

            if file_name.eql? false or file_name.nil?
              count = 0
              success_download = false
              while count < 3 and !success_download
                log_message("Couldn't download data files, retrying.. ", Thor::Shell::Color::BLUE)

                file_name = @files.download_data_file(c, dataset_dir)
                success_download = (file_name.eql? false or file_name.nil?)
                count += 1

              end
              if count > 3 or !success_download
                log_message("Couldn't download data files,revoking", Thor::Shell::Color::RED)

                raise Parallel::Kill
              end
            end
            file_path = "#{dataset_dir}/#{file_name}"
            tar_files << file_path
            success = extarct_tar(file_path, dataset_dir)
            if !success
              log_message("Couldn't extract data files,revoking", Thor::Shell::Color::RED)

              raise Parallel::Kill
            end

            FileUtils.rm_rf([file_path])

          end
        rescue Interrupt
          @files.revoke_download(tar_files, updated_idx[:tree].keys)
          return false
        end


        to_delete = []
        delete.each do |d|
          to_delete << "#{dataset_dir}/#{d}"
        end
        FileUtils.rm_rf(to_delete)

        @dataset.update_idx(updated_idx)


        check = Helpers.checkmark()
        log_message("#{check} Downloaded changes successfully", Thor::Shell::Color::GREEN)
        return true


      end
    rescue => e
      log_message("Error occurd, \nAborting", Thor::Shell::Color::BLUE)
      log_error(e)
      @files.revoke_download(tar_files, updated_idx[:tree].keys)

      exit(1)
    rescue SignalException
      say "\nAborting", Thor::Shell::Color::BLUE
      exit(1)
    end

    desc '', '', :hide => true
    def get_owner_slug(url_or_slug)
      if url_or_slug =~ URI::regexp
        # Find owner and slug in url
        url_parts = url_or_slug.split("/")
        project_index = Cnvrg::Helpers.look_for_in_path(url_or_slug, "datasets")
        slug = url_parts[project_index + 1]
        owner = url_parts[project_index - 1]
      else
        # Find owner in config file
        owner = CLI.get_owner
        slug = url_or_slug
      end
      return owner, slug
    end

    desc '', '', :hide => true
    def data_put(dataset_url, files: [], dir: '', commit: '', chunk_size: 1000, force: false, override: false, threads: 15, message: nil, auto_cache: false, external_disk: nil)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        if auto_cache && external_disk.blank?
          raise SignalException.new(1, "for auto caching external disk is required")
        end
        owner, slug = get_owner_slug(dataset_url)
        @dataset = Dataset.new(dataset_info: {:owner =>  owner, :slug => slug})
        @datafiles = Cnvrg::Datafiles.new(owner, slug, dataset: @dataset)
        @files = @datafiles.verify_files_exists(files)
        @files = @files.uniq { |t| t.gsub('./', '')}

        if @files.blank?
          raise SignalException.new(1, "Cant find files to upload, exiting.")
        end
        log_message("Uploading #{@files.size} files", Thor::Shell::Color::GREEN)
        number_of_chunks = (@files.size.to_f / chunk_size).ceil
        if commit.blank?
          Cnvrg::Logger.info("Creating commit")
          response = @datafiles.start_commit(false, force, chunks: number_of_chunks, message: message )
          unless response #means we failed in the start commit.
            raise SignalException.new(1, "Cant put files into dataset, check the dataset id")
          end
          @commit =  response['result']['commit_sha1']
        elsif commit.eql? "latest"
          Cnvrg::Logger.info("Put files in latest commit")
          response = @datafiles.last_valid_commit()
          unless response #means we failed in the start commit.
            raise SignalException.new(1, "Cant put files into commit:#{commit}, check the dataset id and commit")
          end
          @commit = response['result']['sha1']
        else
          @commit = commit
        end

        # dir shouldnt have starting or ending slash.
        dir = dir[0..-2] if dir.end_with? '/'
        dir = dir[1..-1] if dir.start_with? '/'

        @datafiles.upload_multiple_files_optimized(
          @files,
          @commit,
          override: override,
          chunk_size: chunk_size,
          prefix: dir,
          threads: threads,
        )
        Cnvrg::Logger.info("Finished upload files")
        # This is for backwards compatibility only and should be removed in future versions:
        res = @datafiles.put_commit(@commit)
        unless res.is_success?
          raise SignalException.new(1, res.msg)
        end
        Cnvrg::Logger.info("Saving commit on server")
        res = @datafiles.end_commit(@commit,force, success: true, commit_type: "put", auto_cache: auto_cache, external_disk: external_disk)
        msg = res['result']
        response = Cnvrg::Result.new(Cnvrg::CLI.is_response_success(res, true), msg)
        unless response.is_success?
          raise SignalException.new(1, res.msg)
        end

        log_message("Uploading files finished Successfully", Thor::Shell::Color::GREEN)
        if msg['cache_error'].present?
          log_message("Couldn't cache commit: #{msg['cache_error']}", Thor::Shell::Color::YELLOW)
        end
      rescue SignalException => e
        log_message(e.message, Thor::Shell::Color::RED)
        return false
      end
    end

    desc '', '', :hide => true
    def data_rm(dataset_url, regex_list: [], commit: '', message: nil, auto_cache: false, external_disk: nil)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)

        if auto_cache && external_disk.blank?
          raise SignalException.new(1, "for auto caching external disk is required")
        end

        owner, slug = get_owner_slug(dataset_url)
        @dataset = Dataset.new(dataset_info: {:owner =>  owner, :slug => slug})
        @datafiles = Cnvrg::Datafiles.new(owner, slug, dataset: @dataset)

        # Init a new commit
        response = @datafiles.start_commit(false, false, chunks: 1, message: message )
        unless response #means we failed in the start commit.
          raise SignalException.new(1, "Cant put files into dataset, check the dataset id")
        end
        @commit =  response['result']['commit_sha1']

        # Server expects certain regex format with * so fix those that dont comply
        regex_list = regex_list.map do |regex|
          if regex.end_with? "/"
            # if user wants to delete entire folder add regex to delete contents as well
            [regex, "#{regex}*"]
          else
            regex
          end
        end.flatten

        files_to_delete, folders_to_delete, job_id = @datafiles.delete_multiple_files(@commit, regex_list)
        log_message("Deleting #{files_to_delete} files and #{folders_to_delete} folders", Thor::Shell::Color::GREEN)

        total_files = files_to_delete + folders_to_delete
        current_progress = 0
        progressbar = @datafiles.create_progressbar("Delete Progress", total_files)
        chunk_size = 1000
        offset = 0
        while current_progress < total_files
          current_progress = @datafiles.delete_file_chunk(@commit, regex_list, chunk_size, offset)
          progressbar.progress = current_progress
          offset += chunk_size
        end

        res = @datafiles.end_commit(@commit,false, success: true, auto_cache: auto_cache, external_disk: external_disk)
        msg = res['result']
        response = Cnvrg::Result.new(Cnvrg::CLI.is_response_success(res, true), msg)
        unless response.is_success?
          raise SignalException.new(1, res.msg)
        end

        log_message("Deleting files finished Successfully", Thor::Shell::Color::GREEN)
        if msg['cache_error'].present?
          log_message("Couldn't cache commit: #{msg['cache_error']}", Thor::Shell::Color::YELLOW)
        end
      rescue SignalException => e
        log_message(e.message, Thor::Shell::Color::RED)
        return false
      end
    end

    desc 'upload_data', 'Upload data files', :hide => true
    method_option :ignore, :type => :array, :aliases => ["-i", "--i"], :desc => "ignore following files"
    method_option :new_branch, :type => :boolean, :aliases => ["-nb", "--nb"], :desc => "create new branch of commits"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false

    def upload_data(sync = false, direct = false)

      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)

        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug)
        ignore = options[:ignore] || []
        if !@dataset.update_ignore_list(ignore)
          log_message("Couldn't append new ignore files to .cnvrgignore", Thor::Shell::Color::YELLOW)
        end
        result = @dataset.compare_idx(false)

        commit = result["result"]["commit"]
        if commit != @dataset.last_local_commit and !@dataset.last_local_commit.nil? and !result["result"]["tree"]["updated_on_server"].empty?

          log_message("Remote server has an updated version, please run `cnvrg download` first, or alternatively: `cnvrg sync`", Thor::Shell::Color::BLUE)
          exit(1)
        end

        log_message("Comparing local changes with remote version:", Thor::Shell::Color::BLUE, options["verbose"] ? true : false)
        result = result["result"]["tree"]
        # if result["added"].any? {|x| x.include? ".conflict"} or !result["conflicts"].empty?
        #   all = result["added"].select {|x| x.include? ".conflict"} +result["conflicts"].flatten
        #   if all.size == 1
        #     num = "conflict"
        #   else
        #     num =  "conflicts"
        #   end
        #   say "Project contains #{all.size} #{num}:", Thor::Shell::Color::RED
        #   say "#{all.join("\n")}"
        #   say "Please fix #{num}, and retry", Thor::Shell::Color::RED
        #   exit(1)
        #
        # en
        check = Helpers.checkmark()

        if result["added"].empty? and result["updated_on_local"].empty? and result["deleted"].empty?
          log_message("#{check} Dataset is up to date", Thor::Shell::Color::GREEN, (((options["sync"] or sync) and !direct) ? false : true))
          return true
        end
        update_count = 0
        update_total = result["added"].size + result["updated_on_local"].size + result["deleted"].size
        successful_updates = []
        successful_deletions = []
        if options["verbose"]
          if update_total == 1
            log_message("Updating #{update_total} file", Thor::Shell::Color::BLUE)
          else
            log_message("Updating #{update_total} files", Thor::Shell::Color::BLUE)
          end
        else
          log_message("Syncing files", Thor::Shell::Color::BLUE, ((options["sync"] or sync)) ? false : true)

        end

        # Start commit

        commit_sha1 = @files.start_commit(false)["result"]["commit_sha1"]
        # upload / update
        begin
          (result["added"] + result["updated_on_local"]).each do |f|
            absolute_path = "#{@dataset.local_path}/#{f}"
            relative_path = f.gsub(/^#{@dataset.local_path + "/"}/, "")
            if File.directory?(absolute_path)
              resDir = @files.create_dir(absolute_path, relative_path, commit_sha1)
              if resDir
                update_count += 1
                successful_updates << relative_path
              end
            else
              res = @files.upload_file(absolute_path, relative_path, commit_sha1)

              if res
                update_count += 1
                successful_updates << relative_path
              else
                @files.rollback_commit(commit_sha1)
                log_message("Couldn't upload, Rolling Back all changes.", Thor::Shell::Color::RED)
                exit(0)
              end
            end
          end

          # delete
          deleted = update_deleted(result["deleted"])
          deleted.each do |f|
            relative_path = f.gsub(/^#{@dataset.local_path + "/"}/, "")
            if relative_path.end_with?("/")
              if @files.delete_dir(f, relative_path, commit_sha1)
                # update_count += 1
                successful_updates << relative_path
              end
            else
              if @files.delete_file(f, relative_path, commit_sha1)
                # update_count += 1
                successful_updates << relative_path
              end
            end
          end

        rescue SignalException
          @files.rollback_commit(commit_sha1)
          say "User aborted, Rolling Back all changes.", Thor::Shell::Color::RED
          exit(0)
        rescue => e
          log_message("Exception while trying to upload, Rolling back", Thor::Shell::Color::RED)
          log_error(e)
          @files.rollback_commit(commit_sha1)
          exit(0)
        end
        if !result["deleted"].nil? and !result["deleted"].empty?
          update_count += result["deleted"].size
        end
        if update_count == update_total
          res = @files.end_commit(commit_sha1,false)
          if (Cnvrg::CLI.is_response_success(res, false))
            # save idx
            begin
              list_files = []
              list_files.concat successful_deletions
              list_files.concat successful_updates

              @dataset.update_idx_with_files_commits!(list_files, res["result"]["commit_time"])

              @dataset.update_idx_with_commit!(commit_sha1)
            rescue => e
              log_message("Couldn't commit updates, Rolling Back all changes.", Thor::Shell::Color::RED)
              log_error(e)
              @files.rollback_commit(commit_sha1)
              exit(1)

            end
            if options["verbose"]
              log_message("#{check} Done", Thor::Shell::Color::BLUE)
              if successful_updates.size > 0
                log_message("Updated:", Thor::Shell::Color::GREEN)
                suc = successful_updates.map {|x| x = Helpers.checkmark() + " " + x}
                log_message(suc.join("\n"), Thor::Shell::Color::GREEN)
              end
              if successful_deletions.size > 0
                log_message("Deleted:", Thor::Shell::Color::GREEN)
                del = successful_updates.map {|x| x = Helpers.checkmark() + " " + x}
                log_message(del.join("\n"), Thor::Shell::Color::GREEN)
              end
              log_message("Total of #{update_count} / #{update_total} files.", Thor::Shell::Color::GREEN)
            else
              if (options["sync"] or sync) and direct
                log_message("#{check} Syncing dataset completed successfully", Thor::Shell::Color::GREEN)

              else
                log_message("#{check} Changes were updated successfully", Thor::Shell::Color::GREEN)

              end

            end

          else
            @files.rollback_commit(commit_sha1)
            log_message("Error: Couldn't commit. \nRolling Back all changes.", Thor::Shell::Color::RED)
          end
        else
          log_message("Error: Uploaded only #{update_count}/#{update_total} files, \nRolling back", Thor::Shell::Color::RED)

          @files.rollback_commit(commit_sha1)
        end
      rescue => e
        log_message("Error occurd, \nAborting", Thor::Shell::Color::RED)
        log_error(e)

        @files.rollback_commit(commit_sha1)
        exit(1)
      rescue SignalException

        say "\nAborting", Thor::Shell::Color::BLUE
        say "\nRolling back all changes", Thor::Shell::Color::BLUE
        @files.rollback_commit(commit_sha1)
        exit(1)
      end

    end


    desc 'data upload', 'Upload files from local dataset directory to remote server', :hide => true
    method_option :ignore, :type => :array, :aliases => ["-i", "--i"], :desc => "ignore following files"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :no_compression, :type => :boolean, :aliases => ["-nc", "--no_compression"], :default => false

    def upload_data_tar(ignore, verbose, sync, no_compression)

      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        dataset_dir = is_cnvrg_dir(Dir.pwd)

        @dataset = Dataset.new(dataset_dir)

        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug)
        if !@dataset.update_ignore_list(ignore)
          log_message("Couldn't append new ignore files to .cnvrgignore", Thor::Shell::Color::RED)
          exit(1)
        end
        log_message("Checking dataset", Thor::Shell::Color::BLUE)
        ignore_list = @dataset.get_ignore_list()
        local_idx = @dataset.generate_idx(ignore_list)

        result = @dataset.compare_idx(false, commit = @dataset.last_local_commit, local_idx = local_idx)

        commit = result["result"]["commit"]
        if commit != @dataset.last_local_commit and !@dataset.last_local_commit.nil? and !result["result"]["tree"]["updated_on_server"].empty?

          log_message("Remote server has an updated version, please run `cnvrg data download` first", Thor::Shell::Color::BLUE)
          exit(1)
        end

        log_message("Comparing local changes with remote version:", Thor::Shell::Color::BLUE, verbose)
        result = result["result"]["tree"]
        check = Helpers.checkmark()

        if result["added"].empty? and result["updated_on_local"].empty? and result["deleted"].empty?
          log_message("#{check} Dataset is up to date", Thor::Shell::Color::GREEN, (sync ? false : true))
          return true
        end
        update_count = 0
        update_total = result["added"].size + result["updated_on_local"].size + result["deleted"].size
        successful_updates = []
        successful_deletions = []

        # Start commit
        res = @files.start_commit(false)["result"]
        commit_sha1 = res["commit_sha1"]
        commit_time = res["commit_time"]
        # upload / update
        begin
          (result["added"] + result["updated_on_local"]).each do |f|
            relative_path = f.gsub(/^#{@dataset.local_path + "/"}/, "")
            successful_updates << relative_path
            update_count += 1
          end

          # delete
          deleted = update_deleted(result["deleted"])
          deleted.each do |f|
            relative_path = f.gsub(/^#{@dataset.local_path + "/"}/, "")
            successful_updates << relative_path
          end
          @dataset.update_idx_with_files_commits!((successful_deletions+successful_updates), commit_time)

          log_message("Compressing data", Thor::Shell::Color::BLUE)

          home_dir = File.expand_path('~')
          compression_path = get_compression_path
          tar_path = "#{compression_path}#{@dataset.slug}_#{commit_sha1}.tar.gz"
          tar_files_path = "#{home_dir}/.cnvrg/tmp/#{@dataset.slug}_#{commit_sha1}.txt"
          files_to_upload = result["added"] + result["updated_on_local"]
          if File.exist? (@dataset.local_path + "/.cnvrgignore")
            files_to_upload << ".cnvrgignore"
          end
          tar_files = (files_to_upload).join("\n")
          File.open(tar_files_path, 'w') {|f| f.write tar_files}
          ignore_files_path = nil
          if !ignore_list.nil?
            ignore_files_path = "#{home_dir}/.cnvrg/tmp/#{@dataset.slug}_#{commit_sha1}_ignore.txt"
            File.open(ignore_files_path, 'w') {|f| f.write ignore_list.join("\n")}
          end
          is_tar = create_tar(dataset_dir, tar_path, tar_files_path, no_compression, ignore_files_path)
          if !is_tar
            log_message("ERROR: Couldn't compress data", Thor::Shell::Color::RED)
            FileUtils.rm_rf([tar_path]) if File.exist? tar_path
            FileUtils.rm_rf([tar_files_path]) if File.exist? tar_files_path
            FileUtils.rm_rf([ignore_files_path]) if !ignore_files_path.nil? and File.exist? ignore_files_path

            @files.rollback_commit(commit_sha1)
            log_message("Rolling Back all changes.", Thor::Shell::Color::RED)
            exit(1)
          end
          log_message("Uploading data", Thor::Shell::Color::BLUE)
          log_file = "#{home_dir}/.cnvrg/tmp/upload_#{File.basename(tar_path)}.log"
          res = false
          res = @files.upload_tar_file(tar_path, tar_path, commit_sha1)

          if res
            log_message("Commiting data", Thor::Shell::Color::BLUE)

            cur_idx = @dataset.get_idx.to_h

            res = @files.end_commit_tar(commit_sha1, cur_idx)
            if !Cnvrg::CLI.is_response_success(res, false)
              FileUtils.rm_rf([tar_files_path]) if File.exist? tar_files_path
              FileUtils.rm_rf([tar_path]) if File.exist? tar_path


              @files.rollback_commit(commit_sha1)
              log_message("Can't commit, Rolling Back all changes.", Thor::Shell::Color::RED)
              exit(1)
            end

          else
            if File.exist? log_file
              @files.upload_data_log_file(log_file, log_file, commit_sha1)
            end


            FileUtils.rm_rf([tar_files_path]) if File.exist? tar_files_path
            FileUtils.rm_rf([tar_path]) if File.exist? tar_path


            @files.rollback_commit(commit_sha1)
            log_message("Can't upload, Rolling Back all changes.", Thor::Shell::Color::RED)
            log_message("Upload error log: #{log_file}", Thor::Shell::Color::RED)

            exit(1)
          end


          # delete
          FileUtils.rm_rf([tar_path, tar_files_path])

        rescue SignalException
          FileUtils.rm_rf([tar_files_path]) if File.exist? tar_files_path
          FileUtils.rm_rf([tar_path]) if File.exist? tar_path
          if File.exist? log_file
            @files.upload_data_log_file(log_file, log_file, commit_sha1)
          end


          @files.rollback_commit(commit_sha1)
          say "User aborted, Rolling Back all changes.", Thor::Shell::Color::RED
          exit(0)
        rescue => e
          log_error(e)
          # if !Cnvrg::Helpers.internet_connection?
          #   say "Seems there is no internet connection", Thor::Shell::Color::RED
          #
          # end
          if File.exist? log_file
            @files.upload_data_log_file(log_file, log_file, commit_sha1)
          end
          FileUtils.rm_rf([tar_files_path]) if File.exist? tar_files_path
          FileUtils.rm_rf([tar_path]) if File.exist? tar_path

          @files.rollback_commit(commit_sha1)
          log_message("Exception while trying to upload, \nRolling back,\n look at the log for more details", Thor::Shell::Color::RED)
          log_message("Error log: #{log_file}", Thor::Shell::Color::RED)


          exit(0)
        end
        log_message("#{check} Changes were updated successfully", Thor::Shell::Color::GREEN)


      rescue => e

        log_message("Error occurred, \nAborting", Thor::Shell::Color::RED)
        log_error(e)
        @files.rollback_commit(commit_sha1)
        exit(1)
      rescue SignalException

        say "\nAborting", Thor::Shell::Color::BLUE
        say "\nRolling back all changes", Thor::Shell::Color::BLUE
        @files.rollback_commit(commit_sha1)
        exit(1)
      end


    end


    desc 'unlink', 'Unlink a project from current directory', :hide => true

    def create_volume
      verify_logged_in(false)
      log_start(__method__, args, options)
      dataset_dir = is_cnvrg_dir(Dir.pwd)
      @dataset = Dataset.new(dataset_dir)
      @dataset.create_volume()

    end

    desc 'data list', 'List all dataset you currently have', :hide => true

    def list_dataset
      verify_logged_in(false)
      log_start(__method__, args, options)
      dataset_dir = is_cnvrg_dir(Dir.pwd)
      @dataset = Dataset.new(dataset_dir)
      owner = @dataset.owner
      if owner.nil? or owner.empty?
        owner = CLI.get_owner()
      end

      result = @dataset.list(owner)
      Cnvrg::CLI.is_response_success(result)

        list = result["result"]["list"]

        print_table(list)


    end

    desc 'data queries', 'List all data search queries you currently have', :hide => true

    def queries
      verify_logged_in(false)
      log_start(__method__, args, options)
      dataset_dir = is_cnvrg_dir(Dir.pwd)
      @dataset = Dataset.new(dataset_dir)
      result = @dataset.search_queries()
      print_table(result)
    end

    desc 'data download_tags_yaml', 'Download dataset tags yml files in current directory', :hide => true

    def download_tags_yaml
      verify_logged_in(false)
      log_start(__method__, args, options)
      dataset_dir = is_cnvrg_dir(Dir.pwd)
      @dataset = Dataset.new(dataset_dir)
      status = @dataset.download_tags_yaml()
      if status
        log_message("Downloaded tags yaml successfully", Thor::Shell::Color::GREEN)
      else
        log_message("Unable to download", Thor::Shell::Color::RED)
      end
    end

    desc 'data query_files', 'List all data search queries you currently have', :hide => true
    def query_files(query)
      verify_logged_in(false)
      log_start(__method__, args, options)
      dataset_dir = is_cnvrg_dir(Dir.pwd)
      @dataset = Dataset.new(dataset_dir)
      query = options["query"] || query
      result = @dataset.get_query_file(query)
      print_table(result)
    end

    desc 'data commits', 'List all commits for a specific dataset', :hide => true
    def list_dataset_commits(dataset_url, commit_sha1: nil)
      verify_logged_in(false)
      log_start(__method__, args, options)

      if dataset_url == "."
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)
      else
        owner, slug = get_owner_slug(dataset_url)
        @dataset = Dataset.new(dataset_info: {:owner =>  owner, :slug => slug})
      end

      result = @dataset.list_commits(commit_sha1:commit_sha1)
      list = result["result"]["list"]

      print_table(list)
    end

    desc 'commits', 'List all commits for a specific Project', :hide => true
    def list_commits()
      verify_logged_in(true)
      log_start(__method__, args, options)

      project_dir = is_cnvrg_dir(Dir.pwd)
      @project = Project.new(project_dir)
      result = @project.list_commits()
      list = result["result"]["list"]
      print_table(list)

    end


    desc 'unlink', 'Unlink a project from current directory', :hide => true

    def unlink
      verify_logged_in(false)
      log_start(__method__, args, options)
      working_dir = is_cnvrg_dir()
      list_to_del = [working_dir + "/.cnvrg"]
      FileUtils.rm_rf list_to_del
    end



    desc 'git_clone', 'Clone project'
    method_option :soft, :type => :boolean, :aliases => ["-s", "--soft"], :default => false, :hide => true
    def git_clone(slug, owner)
      verify_logged_in(false)
      log_start(__method__, args, options)
      project_home = Dir.pwd
      soft = options["soft"] || false
      Project.stop_if_project_present(project_home, slug, owner) if soft
      clone_resp = Project.clone_dir_remote(slug, owner, slug,true)
      exit 1 if not clone_resp
      idx_status = Project.new(get_project_home).generate_idx(files:[])
      FileUtils.mkdir_p File.join(get_project_home, ENV['CNVRG_OUTPUT_DIR']) if ENV['CNVRG_OUTPUT_DIR'].present?
    end


    desc 'link_git CNVRG_PROJECT_URL', 'Link git project to existed cnvrg project'
    method_option :git, :type => :boolean, :aliases => ["-g", "--git"], :default => false
    def link_git(project_url)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        url_parts = project_url.split("/")
        project_index = Cnvrg::Helpers.look_for_in_path(project_url, "projects")
        slug = url_parts[project_index + 1]
        owner = url_parts[project_index - 1]
        response = Cnvrg::API.request("users/#{owner}/projects/#{slug}/get_project", 'GET')
        Cnvrg::CLI.is_response_success(response)
        response = JSON.parse response["result"]
        project_name = response["title"]

        log_message("Linking #{project_name}", Thor::Shell::Color::BLUE)
        clone_resp = Project.clone_dir_remote(slug, owner, project_name, true)
        idx_status = Project.new(get_project_home).generate_idx
        log_message("Linking project #{project_name} successfully", Thor::Shell::Color::GREEN)

        return
      rescue => e
        log_message("Error occurred, \nAborting", Thor::Shell::Color::RED)
        log_error(e)
        return
      rescue SignalException

        say "\nAborting", Thor::Shell::Color::BLUE
        return
      end

    end

    desc 'clone PROJECT_URL', 'Clone project'
    method_option :remote, :type => :boolean, :aliases => ["-r", "--r"], :default => false
    method_option :commit, :type => :string, :aliases => ["-c", "--c"], :default => nil
    method_option :soft, :type => :boolean, :aliases => ["-s", "--soft"], :default => false, :hide => true
    method_option :threads, :type => :numeric, :aliases => ["--threads"], :default => 15
    def clone(project_url)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        url_parts = project_url.split("/")
        project_index = Cnvrg::Helpers.look_for_in_path(project_url, "projects")
        slug = url_parts[project_index + 1]
        owner = url_parts[project_index - 1]
        remote = options["remote"] || false
        soft = options["soft"] || false
        threads = options[:threads] || Cnvrg::Helpers.parallel_threads

        response = Cnvrg::API.request("users/#{owner}/projects/#{slug}/get_project", 'GET')
        Cnvrg::CLI.is_response_success(response)
        response = JSON.parse response["result"]
        project_name = response["title"]
        git = response["git"] || false

        commit_to_clone = options["commit"] || nil

        log_message("Cloning #{project_name}", Thor::Shell::Color::BLUE)
        clone_resp = false
        project_home = Dir.pwd

        Project.stop_if_project_present(project_home, project_name, owner) if soft

        if remote and !git
          clone_resp = Project.clone_dir_remote(slug, owner, project_name,git)
        elsif git
          if remote
            clone_resp = Project.clone_dir_remote(slug, owner, project_name,git)
          else
            project_home += "/#{project_name}"
            clone_resp = Project.clone_dir(slug, owner, project_name,git)

          end
        else
          if (Dir.exists? project_name)
            # project_name = "#{project_name}_#{rand(1 .. 5000000000)}"
            # puts project_name
            log_message("Error: Conflict with dir #{project_name}", Thor::Shell::Color::RED)
            if no? "Sync to repository anyway? (current data might lost)", Thor::Shell::Color::YELLOW
              log_message("Remove dir in order to clone #{project_name}", Thor::Shell::Color::RED)
              exit(1)
            end

          end
          clone_resp = Project.clone_dir(slug, owner, project_name,git)
          project_home = Dir.pwd + "/" + project_name
        end

        if clone_resp
          @project = Project.new(project_home)
          @files = Cnvrg::Files.new(@project.owner, slug, project_home: project_home, project: @project)
          response = @project.clone(remote, commit_to_clone)
          Cnvrg::CLI.is_response_success response
          commit_sha1 = response["result"]["commit"]
          files = response["result"]["tree"].keys
          idx = {commit: response["result"]["commit"], tree: response["result"]["tree"]}
          log_message("Downloading files", Thor::Shell::Color::BLUE)
          progressbar = @files.create_progressbar(files.size, "Clone Progress")
          @files.download_files(files, commit_sha1, progress: progressbar, threads: threads)
          progressbar.finish
          Project.verify_cnvrgignore_exist(project_name, remote)
          Cnvrg::Logger.log_info("Generating idx")
          @project.set_idx(idx)
          log_message("Done")
          log_message("Downloaded #{files.size} files")
        end
      end
    end


    desc 'status', 'Show the working tree status'
    method_option :new_branch, :type => :boolean, :aliases => ["-nb", "--nb"], :desc => "create new branch of commits"
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false

    def status
      begin
        verify_logged_in()
        log_start(__method__, args, options)
        @project = Project.new(get_project_home)

        new_branch = options["new_branch"] || false
        force = options["force"] || false

        result = @project.compare_idx(new_branch,force:force)["result"]
        commit = result["commit"]
        result = result["tree"]
        log_message("Comparing local changes with remote version:", Thor::Shell::Color::BLUE)

        if result["added"].empty? and result["updated_on_local"].empty? and result["updated_on_server"].empty? and result["deleted"].empty? and result["conflicts"].empty?
          log_message("Project is up to date", Thor::Shell::Color::GREEN)
          return true
        end
        if result["added"].size > 0
          log_message("Added files:\n", Thor::Shell::Color::BLUE)
          result["added"].each do |a|
            log_message("\t\tA:\t#{a}", Thor::Shell::Color::GREEN)
          end
        end

        if result["deleted"].size > 0
          log_message("Deleted files:\n", Thor::Shell::Color::BLUE)
          result["deleted"].each do |a|
            log_message("\t\tD:\t#{a}", Thor::Shell::Color::GREEN)
          end
        end
        if result["updated_on_local"].size > 0
          log_message("Local changes:\n", Thor::Shell::Color::BLUE)
          result["updated_on_local"].each do |a|
            log_message("\t\tM:\t#{a}", Thor::Shell::Color::GREEN)
          end
        end

        if result["updated_on_server"].size > 0
          log_message("Remote changes:\n", Thor::Shell::Color::BLUE)
          result["updated_on_server"].each do |a|
            log_message("\t\tM:\t#{a}", Thor::Shell::Color::GREEN)
          end
        end

        if result["conflicts"].size > 0
          log_message("Conflicted changes:\n", Thor::Shell::Color::BLUE)
          result["conflicts"].each do |a|
            log_message("\t\tC:\t#{a}", Thor::Shell::Color::RED)
          end
        end
      rescue SignalException
        say "\nAborting"
        exit(1)
      end
    end

    desc '', '', :hide => true

    def revert_exp
      begin
        log_start(__method__, args, options)
        @project = Project.new(get_project_home)
        ignore_list = @project.get_ignore_list()

        result = @project.compare_idx(false)["result"]
        result = result["tree"]
        if result["added"].size > 0
          FileUtils.rm_rf(result["added"])
        end
        say "Changes were removed successfully", Thor::Shell::Color::GREEN


      rescue SignalException
        log_end(-1)
        say "\nAborting"
        exit(1)
      end
    end
    desc 'sync_data_new', 'sync_data_new', :hide=> true
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s","--sync"], :default => false
    method_option :tags, :type => :string, :aliases => ["--tags"], :desc => "upload file tags", :default => ""
    method_option :commit, :type => :string, :aliases => ["-c"], :desc => "download specified commit", :default => nil
    method_option :all_files, :type => :boolean, :aliases => ["--all"], :desc => "download specified commit", :default => true
    method_option :parallel, :type => :numeric, :aliases => ["-p", "--parallel"], :desc => "uparallel upload at the same time", :default => 15
    method_option :init, :type => :boolean, :aliases => ["--initial"], :desc => "initial sync", :default => false
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil
    def sync_data_new(new_branch, force, verbose, commit, all_files, tags ,parallel, chunk_size, init, message)
      log_message("This method is deprecated, please use 'data put' instead. for more info visit our docs: https://app.cnvrg.io/docs/cli/install.html#upload-files-to-a-dataset", Thor::Shell::Color::BLUE, !options["verbose"])
      return
      verify_logged_in(true)
      log_start(__method__, args, options)
      log_message('Syncing dataset', Thor::Shell::Color::BLUE, !options["verbose"])
      if !force and !init
        # w(verbose=false, new_branch=false,sync=false, commit=nil,all_files=true)
        total_deleted, total_downloaded = invoke :download_data_new,[verbose, new_branch, true, commit, all_files], :new_branch=>new_branch, :direct=>false, :force =>force
      end

      invoke :upload_data_new,[new_branch, verbose, true, force, tags, chunk_size, message:message, total_deleted: total_deleted, total_downloaded: total_downloaded],
             :new_branch=>new_branch, :direct=>false, :force =>force, :sync =>true, :tags =>tags, :parallel => parallel, :message => message

    end


    desc 'upload_data_new', 'upload_data_new', :hide => true
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s","--sync"], :default => false
    method_option :tags, :type => :boolean, :aliases => ["--tags"], :desc => "upload file tags", :default => false
    method_option :parallel, :type => :numeric, :aliases => ["-p", "--parallel"], :desc => "uparallel upload at the same time", :default => 15
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil

    def upload_data_new(new_branch, verbose, sync, force, tags, chunk_size, message:nil, total_deleted: 0, total_downloaded: 0)
      log_message("This method is deprecated, please use 'data put' instead. for more info visit our docs: https://app.cnvrg.io/docs/cli/install.html#upload-files-to-a-dataset", Thor::Shell::Color::BLUE, !options["verbose"])
      return
      begin
        commit, files_list = invoke :start_commit_data,[], :new_branch=> new_branch, :direct=>false, :force =>force, :chunk_size => chunk_size, :message => message
        files_to_upload, upload_errors = invoke :upload_data_files,[commit, files_list: files_list],:new_branch=>new_branch, :verbose =>verbose, :force =>force, :sync =>sync, :chunk_size => chunk_size

        upload_size = files_to_upload + upload_errors.try(:size) rescue 0
        invoke :end_commit_data,[commit, success: true, uploaded_files: files_to_upload, sync: sync], :new_branch=>new_branch, :force =>force
        if tags
          log_message('Uploading Tags', Thor::Shell::Color::BLUE)
          dataset_dir = is_cnvrg_dir(Dir.pwd)
          @dataset = Dataset.new(dataset_dir)
          begin
            tag_file = File.open(options[:tags], "r+")
            status = @dataset.upload_tags_via_yml(tag_file)
          rescue
            log_message('Tags file not found', Thor::Shell::Color::RED)
            return
          end
          if status
            log_message('Tags are successfully uploaded', Thor::Shell::Color::GREEN)
          else
            log_message('There was some error in uploading Tags', Thor::Shell::Color::RED)
          end
        end
        if total_deleted > 0
          log_message("#{total_deleted} files deleted successfully.", Thor::Shell::Color::GREEN)
        end

        if total_downloaded > 0
          log_message("#{total_downloaded} files downloaded successfully.", Thor::Shell::Color::GREEN)
        end
        if upload_size > 0
          log_message("#{files_to_upload}/#{upload_size} files uploaded successfully.", Thor::Shell::Color::GREEN)
        end

        if upload_errors.try(:size) > 0
          log_message("#{upload_errors.try(:size)}/#{upload_size} files didn't upload:", Thor::Shell::Color::RED)
          upload_errors.each do |file_hash|
            log_message("#{file_hash[:absolute_path]}", Thor::Shell::Color::RED)
          end
        end
      rescue => e
        Cnvrg::CLI.log_message(e.message, 'red')
        Cnvrg::Logger.log_error(e)
        say "\nAborting", Thor::Shell::Color::BLUE
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        return false if dataset_dir.blank?
        @dataset = Dataset.new(dataset_dir)
        return false
      rescue SignalException => e
        Cnvrg::Logger.log_error(e)
        say "\nAborting", Thor::Shell::Color::BLUE
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        return false if dataset_dir.blank?
        @dataset = Dataset.new(dataset_dir)
        return false
      end
    end

    desc 'start_commit', 'start data commit', :hide => true
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :direct, :type => :boolean, :aliases => ["-d", "--direct"], :desc => "was called directed", :default => true
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false
    method_option :chunk_size, :type => :numeric, :aliases => ["-ch"], :default => 0
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil

    def start_commit_data()
      verify_logged_in(true)
      log_start(__method__, args, options)
      dataset_dir = is_cnvrg_dir(Dir.pwd)
      new_branch = options["new_branch"] || false
      force = options["force"] || false
      chunk_size = options["chunk_size"] || false
      message = options["message"]
      @dataset = Dataset.new(dataset_dir)
      @dataset.backup_idx
      @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug, dataset: @dataset)
      next_commit = @dataset.get_next_commit #if there was a partial commit..
      files_list = @dataset.list_all_files
      chunks = (files_list.length.to_f / chunk_size).ceil
      resp = @files.start_commit(new_branch, force, chunks: chunks, dataset: @dataset, message: message)
      if !resp['result']['can_commit']
        log_message("Cant upload files because a new version of this dataset exists, please download it or upload with --force", Thor::Shell::Color::RED)
        exit(1)
      end
      commit_sha1 = resp["result"]["commit_sha1"]
      unless commit_sha1.eql? next_commit
        @dataset.set_partial_commit(next_commit)
      end
      @dataset.set_next_commit(commit_sha1)
      return commit_sha1, files_list
    end


    desc 'end_commit', 'start data commit', :hide => true
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false

    def end_commit_data(commit, success: true, uploaded_files: 0, sync: false)
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)
        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug, dataset: @dataset)
        force = options["force"] || false
        resp = @files.end_commit(commit, force, success: success, uploaded_files: uploaded_files)
        if (resp.present? and resp["result"])
          check = Helpers.checkmark
          if resp["result"]["new_commit"].blank?
            @dataset.revert_next_commit #removes the next commit
            log_message("#{check} Dataset is up to date", Thor::Shell::Color::GREEN)
          else
            if sync
              message = "#{check} Data sync finished"
            else
              message = "#{check} Data upload finished"
            end
            log_message(message, Thor::Shell::Color::GREEN)
            @dataset.remove_next_commit #takes the next commit and put it as current commit
            @dataset.set_partial_commit(nil)
            @dataset.backup_idx
          end
        end
      end
    end
    desc 'list_files', 'list files in dataset', :hide => true
    method_option :json, :type => :boolean, :aliases => ["-j","--json"],:default => true,   :desc => "response as json"
    method_option :commit, :type => :string, :aliases => ["-c","--commit"], :default => nil

    def list_files_dataset()
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        commit = options[:commit]
        as_json = options[:json]
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)

        resp = @dataset.list_files(commit, as_json)
        if (resp and resp["result"])
          if as_json
            puts resp["result"]
          else
            print_table(resp["result"])

          end

        end


      rescue => e
        puts e
      rescue SignalException
        @dataset.set_next_commit(commit)
        log_message("Aborting", Thor::Shell::Color::YELLOW)
        exit(1)
      end

    end
    desc 'upload_data', 'Upload updated files', :hide => true
    method_option :ignore, :type => :string, :aliases => ["-i"], :desc => "ignore following files", :default => ""
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false
    method_option :tags, :type => :string, :aliases => ["--tags"], :desc => "upload file tags", :default => ""
    method_option :chunk_size, :type => :numeric, :aliases => ["--chunk"], :desc => "upload file tags", :default => 1000
    # method_option :tags_yml, :type => :boolean, :aliases => ["--file_tag_yml"], :default => false
    method_option :parallel, :type => :numeric, :aliases => ["-p", "--parallel"], :desc => "uparallel upload at the same time", :default => 15

    def upload_data_files(new_commit, files_list: [])
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)
        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug, dataset: @dataset)
        new_commit ||= @dataset.get_next_commit
        partial_commit = @dataset.get_partial_commit
        if new_commit.blank?
          log_message("You must specify commit, run start_commit to create new commit", Thor::Shell::Color::RED)
          return false
        end
        chunk_size = options[:chunk_size]
        chunk_size = [chunk_size, 1].max
        new_branch = options["new_branch"] || false
        new_tree = {}
        force = options["force"] || false
        parallel_threads = options["parallel"] || ParallelThreads
        all_files = files_list
        all_files = @dataset.list_all_files if files_list.blank?
        files_uploaded = 0
        upload_errors = []

        all_files.each_slice(chunk_size).each do |list_files|
          Cnvrg::Logger.log_info("Uploading files into #{@dataset.slug}, #{files_uploaded} files uploaded")
          temp_tree = @dataset.generate_chunked_idx(list_files, threads: parallel_threads)
          upload_resp, upload_error_files = @files.upload_multiple_files(new_commit, temp_tree,
                                                                         threads: parallel_threads,
                                                                         force: force,
                                                                         new_branch: new_branch,
                                                                         partial_commit: partial_commit,
                                                                         total: all_files.length)

          files_uploaded += upload_resp
          upload_errors += upload_error_files if upload_error_files.present?
          temp_tree.each do |k, v|
            new_tree[k] = (v.present?) ? {sha1: v.try(:fetch, :sha1, nil), commit_time: nil} : nil
          end
        end

        @dataset.write_tree(new_tree) #we dont want to re-run it every time so just on finish.
      rescue => e
        Cnvrg::Logger.log_error(e)
        raise e
      end
      return files_uploaded, upload_errors.try(:flatten).try(:compact)
    end


    desc 'upload', 'Upload updated files'
    method_option :ignore, :type => :string, :aliases => ["-i"], :desc => "ignore following files", :default => ""
    method_option :new_branch, :type => :boolean, :aliases => ["-nb", "--new_branch"], :desc => "create new branch of commits"
    method_option :in_exp, :type => :boolean, :aliases => ["-ie", "--in-exp"], :desc => "In Experiment"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false
    method_option :message, :type => :string, :aliases => ["-m", "--message"], :default => ""
    method_option :deploy, :type => :boolean, :aliases => ["-d", "--deploy"], :default => false
    method_option :return_id, :type => :boolean, :aliases => ["-r", "--return_id"], :default => false
    method_option :files, :type => :string, :aliases => ["--files"], :default => nil
    method_option :output_dir, :type => :string, :aliases => ["--output_dir"], :default => nil
    method_option :git_diff, :type => :boolean, :aliases => ["--git_diff"], :default => false
    method_option :job_slug, :type => :string, :aliases => ["--job"], :default => nil, :hide=>true
    method_option :job_type, :type => :string, :aliases => [ "--job_type"], :default => nil, :hide=>true
    method_option :suppress_exceptions, :type => :boolean, :aliases => ["--suppress-exceptions"], :default => true
    method_option :debug_mode, :type => :boolean, :aliases => ["--debug-mode"], :default => false
    method_option :chunk_size, :type => :numeric, :aliases => ["--chunk"], :default => 1000
    method_option :local, :type => :boolean, :aliases => ["--local"], :default => true

    def upload(link = false, sync = false, direct = false, ignore_list = "", in_exp = false, force = false, output_dir = "output", job_type = nil, job_slug = nil, suppress_exceptions = true,chunk_size=1000)
      begin
        # we are passing "force" twice.. doesnt really make sense :\\
        verify_logged_in(true)
        log_start(__method__, args, options)
        @project = Project.new(get_project_home)
        chunk_size = chunk_size ? chunk_size : options["chunk_size"]

        # Enable local/experiment exception logging
        suppress_exceptions = suppress_exceptions ? suppress_exceptions : options[:suppress_exceptions]
        if in_exp
          exp_obj = Experiment.new(@project.owner, @project.slug, job_id: job_slug)
        else
          exp_obj = nil
        end

        local = options["local"]

        commit_msg = options["message"]
        if commit_msg.nil? or commit_msg.empty?
          commit_msg = ""
        end
        return_id = options["return_id"]
        @files = Cnvrg::Files.new(@project.owner, @project.slug, project_home: get_project_home, project: @project)
        ignore = options[:ignore] || ""
        force = options[:force] || force || false
        spec_files_to_upload = options["files"]
        check = Helpers.checkmark()

        if !spec_files_to_upload.blank?
          spec_files_to_upload = spec_files_to_upload.split(",")
        end
        if @project.is_git
          list = []
          git_output_dir = options["output_dir"] || output_dir
          if git_output_dir.present?
            if git_output_dir.ends_with? "/"
              git_output_dir = git_output_dir[0..-2]
            end
            list = @project.generate_output_dir(git_output_dir, local: local)
          end
          list += @project.generate_git_diff if options["git_diff"]
          spec_files_to_upload = list
          if spec_files_to_upload.blank?
            log_message("#{check} Project is up to date", Thor::Shell::Color::GREEN, (((options["sync"] or sync) and !direct) ? false : true))
            return true
          end
        end

        if ignore.nil? or ignore.empty?
          ignore = ignore_list
        end

        if job_type != "Experiment"
          data_ignore = data_dir_include()
        end

        if !data_ignore.nil?
          if ignore.nil? or ignore.empty?
            ignore = data_ignore
          else
            ignore = "#{ignore},#{data_ignore}"
          end
        end
        if !@project.update_ignore_list(ignore)
          log_message("Couldn't append new ignore files to .cnvrgignore", Thor::Shell::Color::YELLOW)
        end
        new_branch = options["new_branch"] || @project.is_branch

        result = @project.compare_idx(new_branch, force: force, deploy: options["deploy"], in_exp: in_exp, specific_files: spec_files_to_upload)
        commit = result["result"]["commit"]

        if !link
          if (result["result"]["new_version_exist"] and !force) or ((commit != @project.last_local_commit and !@project.last_local_commit.nil? and !result["result"]["tree"]["updated_on_server"].empty?) and !force)
            log_message("Remote server has an updated version, please run `cnvrg download` first, or alternatively: `cnvrg sync`", Thor::Shell::Color::BLUE)
            return false
          end

          log_message("Comparing local changes with remote version:", Thor::Shell::Color::BLUE, (options["verbose"]))
        end
        result = result["result"]["tree"]
        if result["added"].empty? and result["updated_on_local"].empty? and result["deleted"].empty?
          msg = "#{check} Project is up to date"
          if return_id
            Cnvrg::Logger.jsonify_message(msg: msg, success: true)
          else
            log_message(msg, Thor::Shell::Color::GREEN, (((options["sync"] or sync) and !direct) ? false : true))
          end
          return true
        end
        update_count = 0
        update_total = result["added"].size + result["updated_on_local"].size + result["deleted"].size
        if options["verbose"]
          if update_total == 1
            log_message("Updating #{update_total} file", Thor::Shell::Color::BLUE)
          else
            log_message("Updating #{update_total} files", Thor::Shell::Color::BLUE)
          end
        else
          log_message("Syncing files", Thor::Shell::Color::BLUE, ((options["sync"] or sync)) ? false : true)
        end
        # Start commit
        current_commit = nil
        exp_start_commit = nil
        if in_exp || (job_slug.present? and job_type.present?)
          exp_start_commit = @project.last_local_commit
        else
          current_commit = @project.last_local_commit
        end
        job_type = options['job_type'] || job_type
        job_slug = options['job_slug'] || job_slug
        commit_sha1 = @files.start_commit(
            new_branch, force: force, exp_start_commit: exp_start_commit,
            job_type: job_type, job_slug: job_slug, start_commit: current_commit,message: options["message"],
            debug_mode: options["debug_mode"]
        )["result"]["commit_sha1"]
        # upload / update
        # delete
        to_upload = result["added"] + result["updated_on_local"]
        deleted = result["deleted"]
        progressbar = ProgressBar.create(:title => "Upload Progress",
                                         :progress_mark => '=',
                                         :format => "%b>>%i| %p%% %t",
                                         :starting_at => 0,
                                         :total => (to_upload.size + deleted.size),
                                         :autofinish => true)

        buffered_errors = @files.upload_multiple_files(to_upload, commit_sha1, progress: progressbar, suppress_exceptions: suppress_exceptions, chunk_size: chunk_size)
        @files.delete_files_from_server(deleted, commit_sha1, suppress_exceptions: suppress_exceptions)

        progressbar.finish

        if buffered_errors.is_a?(Hash)
          buffered_errors.keys.each do |file|
            to_upload.delete(file)
            Cnvrg::CLI.log_message(buffered_errors[file], 'red')
            exp_obj.job_log([buffered_errors[file]]) unless exp_obj.nil?
          end
        end

        res = @files.end_commit(commit_sha1, force: force, message: commit_msg)
        unless Cnvrg::CLI.is_response_success(res, false)
          raise StandardError.new("Cant end commit")
        end

        # save idx
        @project.update_idx_with_files_commits!((to_upload + deleted), res["result"]["commit_time"])
        @project.update_idx_with_commit!(commit_sha1)
        if options["verbose"]
          log_message("#{check} Done", Thor::Shell::Color::BLUE)
          log_message("Total of #{update_count} / #{update_total} files.", Thor::Shell::Color::GREEN)
        else
          if return_id
            puts "\n"
            print_res = {
                'success' => "true",
                'commit_sha1' => res["result"]["commit_id"]
            }
            puts JSON[print_res]
            return JSON[print_res]
          end
          if (options["sync"] or sync) and direct
            log_message("#{check} Syncing project completed successfully", Thor::Shell::Color::GREEN)
            return true
          else
            log_message("#{check} Changes were updated successfully", Thor::Shell::Color::GREEN)
            return true
          end
        end
      rescue => e
        error_message = "Error occured, #{e.message}\nAborting"
        if e.is_a? SignalException
          say "\nAborting", Thor::Shell::Color::BLUE
          say "\nRolling back all changes", Thor::Shell::Color::BLUE

          exp_obj.job_log(["Aborting", "Rolling back all changes"])  unless exp_obj.nil?
        else
          log_message(error_message, Thor::Shell::Color::RED)
          log_error(e)

          exp_obj.job_log([error_message, e])  unless exp_obj.nil?
        end
        @files.rollback_commit(commit_sha1) unless commit_sha1.nil?
        print_res = {
            'success' => "false",
            'message' => error_message
        }
        puts "\n"
        puts JSON[print_res] if return_id
        return false
      end
    end

    desc 'download_file_data', 'Download one data files', :hide => true
    method_option :verbose, :type => :boolean, :aliases => ["-v", "--verbose"], :default => false
    method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :desc => "download specified commit", :default => nil
    method_option :link, :type => :boolean, :aliases => ["-l","--link"], :desc => "download specified commit", :default => false
    method_option :download_path, :type => :string, :aliases => ["-p", "--path"], :desc => "download specified commit", :default => ""
    method_option :remote, :type => :boolean, :aliases => ["-r","--remote"], :desc => "remote download", :default => false
    method_option :json, :type => :boolean, :aliases => ["-j","--json"],:default => false,   :desc => "response as json"

    def download_file_data(file_path, *dataset_path)

      verify_logged_in(true)
      log_start(__method__, args, options)
      begin
        if dataset_path.nil? or dataset_path.empty?
          dataset_path = Dir.pwd
        elsif dataset_path.is_a? Array
          dataset_path = dataset_path[0]
        end
        dataset_dir = is_cnvrg_dir(dataset_path)
        @dataset = Dataset.new(dataset_dir)
        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug)
        commit_to_download = options["commit"] || nil
        as_link  = options["link"] || false
        download_path = options["path"]
        remote = options["remote"]
        as_json = options["json"]
        if remote
          download_path = "/data/#{@dataset.title}/"

        else
          download_path = dataset_dir
        end
        if !as_json

          log_message("Downloading file", Thor::Shell::Color::BLUE)

        end
        res = @files.download_file_s3(file_path, file_path, download_path, conflict=false, commit_sha1=commit_to_download, as_link=as_link)
        if as_link
          puts res
        else
          if res
            if as_json
              response = {"status":"success"}
              puts response.to_json
            else
              log_message("#{Helpers.checkmark()} File #{file_path} was successfully downloaded", Thor::Shell::Color::GREEN)

            end
          end


        end

      rescue =>e
        log_message("Error occurred, \nAborting", Thor::Shell::Color::BLUE)
        log_error(e)
        exit(1)
      end
    end


    desc 'download_data_new', 'Download updated files', :hide => true
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :commit, :type => :string, :aliases => ["-c"], :desc => "download specified commit", :default => ""
    method_option :all_files, :type => :boolean, :aliases => ["--all"], :desc => "download specified commit", :default => false

    def download_data_new(verbose=false, new_branch=false,sync=false, commit=nil,all_files=true)
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)
        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug, dataset: @dataset)
        res = @dataset.compare_idx_download(all_files: all_files, desired_commit: commit)
        unless CLI.is_response_success(res, false)
          log_message("Cant find the desired commit, please check it or try to download without it.", Thor::Shell::Color::RED)
          exit(1)
        end
        result = res["result"]
        tree = result["tree"]
        commit = result["commit"]
        update_total = [tree['added'], tree["updated_on_server"], tree["conflicts"], tree["deleted"]].compact.flatten.size
        successful_changes  = 0
        if update_total == 0
          log_message("Dataset is up to date", Thor::Shell::Color::GREEN, !sync)
          return 0, 0
        else
          log_message("Downloading #{update_total} files", Thor::Shell::Color::BLUE, options["verbose"])
          log_message("Syncing Dataset", Thor::Shell::Color::BLUE, !sync)
        end
        Cnvrg::Logger.log_info("Current commit: #{@dataset.last_local_commit}, destination commit: #{commit}")
        Cnvrg::Logger.log_info("Compare idx res: #{tree}")
        progressbar = ProgressBar.create(:title => "Download Progress",
                                         :progress_mark => '=',
                                         :format => "%b>>%i| %p%% %t",
                                         :starting_at => 0,
                                         :total => update_total,
                                         :autofinish => true)

        conflicts = @files.mark_conflicts(tree)
        log_message("Found some conflicts, check .conflict files.", Thor::Shell::Color::BLUE) if conflicts > 0
        update_res = @files.download_files_in_chunks(tree["updated_on_server"], progress: progressbar) if tree["updated_on_server"].present?
        added_res = @files.download_files_in_chunks(tree["added"], progress: progressbar) if tree["added"].present?
        deleted = tree["deleted"].to_a
        delete_res = @files.delete_commit_files_local(deleted)

        if !delete_res
          log_message("Couldn't delete #{deleted.join(" ")}", Thor::Shell::Color::RED)
          log_message("Couldn't download, Rolling Back all changes.", Thor::Shell::Color::RED)
          exit(1)
        end

        progressbar.progress += deleted.size if progressbar.present? and deleted.size > 0

        success = (update_res.blank? or update_res.is_success?)
        success &= (delete_res.blank? or delete_res.is_success?)
        success &= (added_res.blank? or added_res.is_success?)

        if success
          # update idx with latest commit
          @dataset.update_idx_with_commit!(commit)
          check = Helpers.checkmark()
          if options["verbose"]
            log_message("#{check} Done, Downloaded:", Thor::Shell::Color::GREEN)
            log_message(successful_changes.join("\n"), Thor::Shell::Color::GREEN)
            log_message("Total of #{successful_changes.size} / #{update_total} files.", Thor::Shell::Color::GREEN)
          else
            log_message("#{check} Downloaded changes successfully", Thor::Shell::Color::GREEN, !sync)
          end

          total_deleted = deleted.try(:size)
          total_downloaded = tree["added"].try(:size) || 0
          total_downloaded +=  tree["updated_on_server"].try(:size) if tree["updated_on_server"].present?

          return total_deleted, total_downloaded
        else
          return []
        end
      rescue SignalException => e
        Cnvrg::Logger.log_error(e)
        say "\nAborting", Thor::Shell::Color::BLUE
        exit(1)
      rescue => e
        Cnvrg::Logger.log_error(e)
        log_message("Error occurred, \nAborting", Thor::Shell::Color::RED)
        exit(1)
      end
    end

    desc 'download in git project', 'Download other files', :hide =>true
    def download_in_git(*commit_sha1)
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        project_home = get_project_home
        @project = Project.new(project_home)
        @files = Cnvrg::Files.new(@project.owner, @project.slug, project: @project, cli: self, options: options)
        commit_sha1 = commit_sha1.try(:first) if commit_sha1.is_a? Array
        @files.download_commit(commit_sha1)
      rescue => e
          log_error(e)
          log_message("Error while trying to download ", Thor::Shell::Color::RED)
          return
      end
    end

    desc 'commit before termination', 'Commit job code before termination', :hide => true
    def commit_before_termination()
      job_type = ENV['CNVRG_JOB_TYPE']
      job_id =  ENV['CNVRG_JOB_ID']
      return unless job_type.present? and job_id.present?
      invoke :sync, [false], :job_slug => job_id, :job_type => job_type, :new_branch => true, :in_exp=> true
    rescue => e
      log_error(e)
    end

    desc 'update_job_commit', 'Update job with its last commit' , :hide => true
    def update_job_commit()
      job_type = ENV['CNVRG_JOB_TYPE']
      job_id =  ENV['CNVRG_JOB_ID']
      return unless job_type.present? and job_id.present?
      verify_logged_in(true)
      log_start(__method__, args, options)
      project_home = get_project_home
      @project = Project.new(project_home)
      current_commit = @project.get_idx[:commit] rescue nil
      commit  = @project.get_job_last_commit(job_type, job_id)
      if commit.present? and commit != current_commit
        invoke :download, [false, "", true ], :commit => commit
      end
    rescue
    end

    desc 'update running jupyter token to server', 'update running jupyter token to server', :hide =>true
    def update_jupyter_token()
      begin
        job_type = ENV['CNVRG_JOB_TYPE']
        job_id =  ENV['CNVRG_JOB_ID']
        return unless job_type.present? and job_id.present?
        verify_logged_in(true)
        log_start(__method__, args, options)
        count = 0
        token = nil
        while count < 20
          res = `jupyter notebook list`
          match = res.match(/token=(\w+)/)
          if match.present?
            token = match[1]
            break
          end
          sleep(0.5)
        end
        if token.blank?
          log_message("Failed to find jupyter token", Thor::Shell::Color::RED)
          return
        end
        log_message("Found token #{token}", Thor::Shell::Color::BLUE)
        project_home = get_project_home
        @project = Project.new(project_home)
        puts(token)
        resp = @project.update_job_jupyter_token(job_type, job_id, token)
        if resp["status"] == 200
          log_message("Updated jupter token successfully", Thor::Shell::Color::BLUE)
        else
          log_message("Failed to update jupyter token ", Thor::Shell::Color::RED)
        end
      rescue => e
        log_error(e)
        log_message("Error while trying to get jupyter token ", Thor::Shell::Color::RED)
        return
      end
    end


    desc 'download', 'Download updated files'
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :ignore, :type => :string, :aliases => ["-i"], :desc => "ignore following files", :default => ""
    method_option :git, :type => :boolean, :aliases => ["--git"], :desc => "download from git projects' commits", :default => false
    method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :desc => "download a specific commit", :default => nil

    def download(sync = false, ignore_list = "", in_exp=false)
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        project_home = get_project_home
        @project = Project.new(project_home)
        @files = Cnvrg::Files.new(@project.owner, @project.slug, project_home: project_home, project: @project)
        git = options["git"]
        commit = options["commit"]
        if git or @project.is_git
          return download_in_git(commit)
        end
        if commit.present?
          return jump(commit)
        end
        ignore = options[:ignore] || ""
        if ignore.nil? or ignore.empty?
          ignore = ignore_list
        end
        data_ignore = data_dir_include()
        if !data_ignore.nil?
          if ignore.nil? or ignore.empty?
            ignore = data_ignore
          else
            ignore = "#{ignore},#{data_ignore}"
          end
        end
        if !@project.update_ignore_list(ignore)
          log_message("Couldn't append new ignore files to .cnvrgignore", Thor::Shell::Color::YELLOW)
        end
        new_branch = options["new_branch"] || @project.is_branch || false
        res = @project.compare_idx(new_branch, in_exp: in_exp, download: true)["result"]
        result = res["tree"]

        commit = res["commit"]

        #here im grouping the files by their current status.
        #
        # all the files that changed in the server (added + updated)
        changed_files = result['updated_on_server'] + result['added']

        # non-conflicted files, all the files that changed remotely but not locally
        updated_files = changed_files - result["update_local"]
        # conflicted - files that changed remotely and locally
        conflicted_files = changed_files & result["update_local"]

        # all deleted files
        all_deleted = result['deleted']
        # cant delete files - files that deleted on the server but changed locally
        conflicted_deleted = all_deleted & result["update_local"]
        # files to delete - files that deleted on the server and unchanged locally
        deleted_files = all_deleted - conflicted_deleted


        update_total = [all_deleted, changed_files ].flatten.size

        if update_total < 1
          if !@project.last_local_commit.eql? commit
            Cnvrg::Logger.log_info("Finish commit, updating idx with commit")
            @project.update_idx_with_commit!(commit)
          end
          log_message("Project is up to date", Thor::Shell::Color::GREEN, ((options["sync"] or sync) ? false : true))
          return true
        end
        Cnvrg::Logger.log_info("Got #{update_total} changes from server")

        successful_changes = []
        if update_total == 1
          log_message("Downloading #{update_total} file", Thor::Shell::Color::BLUE, !options["sync"])
        elsif options["verbose"]
          log_message("Downloading #{update_total} files", Thor::Shell::Color::BLUE)
        else
          log_message("Syncing files", Thor::Shell::Color::BLUE, !options["sync"])
        end

        progressbar = ProgressBar.create(:title => "Download Progress",
                                         :progress_mark => '=',
                                         :format => "%b>>%i| %p%% %t",
                                         :starting_at => 0,
                                         :total => update_total,
                                         :autofinish => true)


        Cnvrg::Logger.log_info("Downloading updated files:#{updated_files.join(",")}")
        @files.download_files(updated_files, commit, progress: progressbar)

        Cnvrg::Logger.log_info("Downloading conflicted files:#{conflicted_files.join(",")}")
        @files.download_files(conflicted_files, commit, postfix: ".conflict", progress: progressbar)

        Cnvrg::Logger.log_info("Delete files: #{deleted_files.join(",")}")
        @files.delete_files_local(deleted_files, conflicted: conflicted_deleted, progress: progressbar)

        # update idx with latest commit
        # the latest true its because if we define --commit in the cmd it will go to "def jump(options['commit'])"
        # so if we are downloads something, we have to stay here.
        @project.update_idx_with_commit!(commit, latest: true)
        #TODO Sync, remove idx, sync again and pray
        progressbar.finish
        check = Helpers.checkmark()
        Cnvrg::Logger.log_info("Finished downloading successfuly")
        if options["verbose"]
          log_message("#{check} Done, Downloaded:", Thor::Shell::Color::GREEN)
          log_message(successful_changes.join("\n"), Thor::Shell::Color::GREEN)
          log_message("Total of #{successful_changes.size} / #{update_total} files.", Thor::Shell::Color::GREEN)
        else
          log_message("#{check} Downloaded changes successfully", Thor::Shell::Color::GREEN, ((sync or options["sync"]) ? false : true))
        end
      rescue => e
        log_message("Error occurred, \nAborting", Thor::Shell::Color::BLUE)
        Cnvrg::Logger.log_error(e)
        exit(1)
      rescue Exception => e
        Cnvrg::Logger.log_error(e)
        log_message("Error occurred, \nAborting", Thor::Shell::Color::BLUE)
        exit(1)
      rescue SignalException
        log_message("\nAborting", Thor::Shell::Color::BLUE)
        exit(1)
      end
    end




    desc 'jump COMMIT_ID', 'Jump to specific commit'
    def jump(commit_sha1)
      begin
        verify_logged_in()
        log_start(__method__, args, options)
        project_home = get_project_home
        @project = Project.new(project_home)
        current_commit = @project.last_local_commit
        if current_commit.start_with? commit_sha1 #commit_sha1 can be partial.
          log_message("Project is already updated", Thor::Shell::Color::GREEN)
          exit(0)
        end
        log_message("Jumping to commit #{commit_sha1}")
        @files = Cnvrg::Files.new(@project.owner, @project.slug, project_home: project_home, project: @project)
        resp = @project.jump_idx(destination: commit_sha1)
        if resp.blank?
          log_message("Cant find the given commit", Thor::Shell::Color::RED)
          exit(0)
        end
        compare = resp['result']['compare']
        latest = resp['result']['latest']
        commit = resp['result']['commit']
        updated_files = compare['updated_on_server'] + compare['added']
        conflicted_files = compare['conflicts']
        conflicted_deleted = compare['delete_conflicts'] || []
        deleted_files = compare['deleted']
        overall_changes = [updated_files, conflicted_files, deleted_files].flatten.size

        progressbar = @files.create_progressbar(overall_changes, "Download Progress")
        @files.download_files(updated_files, commit_sha1, progress: progressbar)
        @files.download_files(conflicted_files, commit_sha1, progress: progressbar, postfix: '.conflicted')
        @files.delete_files_local(deleted_files, progress: progressbar, conflicted: conflicted_deleted)
        progressbar.finish
        @project.update_idx_with_commit!(commit, latest: latest)
        @project.generate_idx

        log_message("Jumped successfuly!", Thor::Shell::Color::GREEN)
      rescue => e
        Logger::log_error(e)
        log_message("Cant jump to the specified commit", Thor::Shell::Color::RED)
      end
    end

    desc 'show', 'Show specific file from a specific commit', :hide => true
    method_option :path, :type => :string, :aliases => ["-p"], :desc => "File path", :default => ""
    method_option :commit, :type => :string, :aliases => ["-c"], :desc => "Commit sha1", :default => nil

    def show
      path = options['path']
      commit = options['commit']
        verify_logged_in(true)
        log_start(__method__, args, options)
        project_home = get_project_home
        @project = Project.new(project_home)



      @files = Cnvrg::Files.new(@project.owner, @project.slug, project: @project)
      begin

        file = @files.show_file_s3(path, commit)

        if file
          puts file
        else
          say "Couldn't find file"
        end
      end
    end


    desc 'data_jump', 'jump to specific commit', :hide => true

    def data_jump(*commit_sha1)
      begin
        verify_logged_in()
        log_start(__method__, args, options)
        dataset_dir = is_cnvrg_dir(Dir.pwd)
        @dataset = Dataset.new(dataset_dir)

        @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug)
        if commit_sha1.nil? or commit_sha1.empty?
          commit_sha1 = @dataset.last_local_commit
        end
        response = @dataset.compare_commits(commit_sha1)
        successful_changes = []
        if !response["result"]["status"].nil?
          idx = {commit: response["result"]["commit"], tree: response["result"]["tree"]}
          File.open(dataset_dir + "/.cnvrg/idx.yml", "w+") {|f| f.write idx.to_yaml}
          status = response["result"]["status"]
          (status["delete"]).each do |f|
            relative_path = f[0].gsub(/^#{@dataset.local_path}/, "")
            FileUtils.rm_rf(relative_path)
          end
          # current_tree = Dir.entries(".").reject { |file| file.start_with? '.' }
          (status["dirs"]).each do |f|
            relative_path = f[0].gsub(/^#{@dataset.local_path}/, "")
            # dir
            if @files.download_dir(dataset_dir, relative_path)
              # current_tree.delete(relative_path[0, relative_path.size-1])
              successful_changes << relative_path
            end
          end
          (status["download"]).each do |f|
            relative_path = f["name"].gsub(/^#{@dataset.local_path}/, "")
            # dir
            if @files.download_file_s3(f["name"], relative_path, dataset_dir, f["sha1"])
              successful_changes << relative_path
            end
          end


          log_message("Done. Jumped to #{commit_sha1} completed successfully", Thor::Shell::Color::GREEN)
        end
      rescue => e
        log_message("Error occurred, Aborting", Thor::Shell::Color::RED)
        log_error(e)

      rescue SignalException
        exit(1)
      end
    end

    desc 'sync', 'Sync with remote server'
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :ignore, :type => :string, :aliases => ["-i", "--ignore"], :default => ""
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false
    method_option :message, :type => :string, :aliases => ["-m", "--message"], :default => ""
    method_option :return_id, :type => :boolean, :aliases => ["-r", "--return_id"], :default => false
    method_option :deploy, :type => :boolean, :aliases => ["-d", "--deploy"], :default => false
    method_option :in_exp, :type => :boolean, :aliases => ["-e", "--in_exp"], :default => false #deprecated..
    method_option :job_slug, :type => :string, :aliases => ["-j", "--job"], :default => nil
    method_option :job_type, :type => :string, :aliases => ["-jt", "--job_type"], :default => nil
    method_option :files, :type => :string, :aliases => ["--files"], :default => nil
    method_option :output_dir, :type => :string, :aliases => ["--output_dir"], :default => 'output'
    method_option :git_diff, :type => :boolean, :aliases => ["--git_diff"], :default => false
    method_option :suppress_exceptions, :type => :boolean, :aliases => ["--suppress-exceptions"], :default => true
    method_option :debug_mode, :type => :boolean, :aliases => ["--debug-mode"], :default => false
    method_option :chunk_size, :type => :numeric, :aliases => ["--chunk"], :default => 1000
    method_option :local, :type => :boolean, :aliases => ["--local"], :default => true

    def sync(direct = true)
      verify_logged_in(true) if direct
      @project = Project.new(get_project_home)
      log_start(__method__, args, options)
      log_message('Checking for new updates from remote version', Thor::Shell::Color::BLUE, options["verbose"])
      log_message('Syncing project', Thor::Shell::Color::BLUE, !options["verbose"])
      job_slug = options['job_slug'] || ENV['CNVRG_JOB_ID']
      job_type = options['job_type'] || ENV['CNVRG_JOB_TYPE']
      is_git = ENV['CNVRG_GIT_PROJECT'] == "true" || @project.is_git
      in_exp = options["in_exp"] || (job_slug.present? and job_type.present?)
      in_exp = false if job_type.present? and job_type == "NotebookSession"
      output_dir = options["output_dir"] || ENV['CNVRG_OUTPUT_DIR']

      run_download = true
      if (job_type == "NotebookSession" and is_git) or job_type == "Experiment" or options['force']
        run_download = false
      end

      if run_download or options['debug_mode']
        invoke :download, [true, "", in_exp ], :new_branch => options["new_branch"], :verbose => options["verbose"], :sync => true
      end
      invoke :upload, [false, true, direct, "", in_exp, options[:force], output_dir, job_type, job_slug], :new_branch => options["new_branch"], :verbose => options["verbose"], :sync => true,
             :ignore => options[:ignore], :force => options[:force], :message => options[:message], :deploy => options["deploy"], :return_id => options["return_id"],
             :files => options["files"], :output_dir => output_dir, :job_slug => job_slug, :job_type => job_type, :suppress_exceptions => options["suppress_exceptions"],
             :debug_mode => options['debug_mode'], :git_diff => options["git_diff"], :chunk_size => options["chunk_size"], :local => options["local"]

    end

    desc 'run cmd', 'Runs an experiment'
    method_option :local, :type => :boolean, :aliases => ["-l", "--local"], :default => false
    method_option :small, :type => :boolean, :aliases => ["-sm", "--small"], :default => false
    method_option :medium, :type => :boolean, :aliases => ["-md", "--medium"], :default => false
    method_option :large, :type => :boolean, :aliases => ["-lg", "--large"], :default => false
    method_option :gpu, :type => :boolean, :aliases => ["--gpu"], :default => false
    method_option :gpuxl, :type => :boolean, :aliases => ["--gpuxl"], :default => false
    method_option :gpuxxl, :type => :boolean, :aliases => ["--gpuxxl"], :default => false
    method_option :machine, :type => :string, :aliases => ["-m", "--machine"], :default => nil
    method_option :sync_before, :type => :boolean, :aliases => ["-sb", "--sync_before"], :default => true
    method_option :sync_after, :type => :boolean, :aliases => ["-sa", "--sync_after"], :default => true
    method_option :title, :type => :string, :aliases => ["-t", "--title"], :default => ""
    method_option :log, :type => :boolean, :aliases => ["--log"], :default => false
    method_option :email_notification, :type => :boolean, :aliases => ["-en", "--email_notification"], :default => false
    method_option :upload_output, :type => :string, :aliases => ["-uo", "--upload_output"], :default => ""
    method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :default => ""
    method_option :schedule, :type => :string, :aliases => ["--schedule"], :default => ""
    method_option :recurring, :type => :string, :aliases => ["--recurring"], :default => ""
    method_option :image, :type => :string, :aliases => ["--image"], :default => nil
    method_option :grid, :type => :string, :aliases => ["-g", "--grid"], :default => ""
    method_option :data, :type => :string, :aliases => ["-d", "--data"], :default => ""
    method_option :datasets, :type => :string, :aliases => ["--datasets"], :desc => "'[{\"id\": \"dataset id\", \"commit\": \"commit id\", \"query\": \"query name\", \"tree_only\": true, \"use_cached\": true]'", :default => ""
    method_option :data_commit, :type => :string, :aliases => ["--data_commit"], :default => ""
    method_option :ignore, :type => :string, :aliases => ["-i", "--ignore"], :desc => "ignore following files", :default => ""
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false
    method_option :sync_before_terminate, :type => :boolean, :aliases => ["-sbt", "--sync_before_terminate"], :default => false
    method_option :periodic_sync, :type => :string, :aliases => ["-ps", "--periodic_sync"], :default => nil #//15,30,45,60
    method_option :max_time, :type => :string, :aliases => [ "--max_time"], :default => nil
    method_option :dataset_only_tree, :type => :boolean, :aliases => [ "--dataset_only_tree"], :default => false
    method_option :output_dir, :type => :string, :aliases => ["-o", "--output_dir"], :default => nil
    method_option :data_query, :type => :string, :aliases => ["-q", "--query"], :default => nil
    method_option :git_commit, :type => :string, :aliases => [ "--git_commit"], :default => nil
    method_option :git_branch, :type => :string, :aliases => [ "--git_branch"], :default => nil
    method_option :restart_if_stuck, :type => :boolean, :aliases => ["--restart","--restart_if_stuck"], :default => nil
    method_option :local_folders, :type => :string, :aliases => ["--local_folders"], :default => nil
    method_option :prerun, :type => :boolean, :aliases => ["-p", "--prerun"], :default => true
    method_option :requirements, :type => :boolean, :aliases => ["-r", "--requirements"], :default => true
    method_option :notify_on_error, :type => :boolean, :aliases => ["-noe", "--notify_on_error"], :default => nil
    method_option :notify_on_success, :type => :boolean, :aliases => ["-nos", "--notify_on_success"], :default => nil
    method_option :emails, :type => :string, :aliases => ["-es", "--emails"], :default => "", :desc => "additional emails to notify on success / or error, comma separated"
    method_option :wait, :type => :boolean, :aliases => ["-w", "--wait"], :default => false, :desc => "keep command session open until experiment finished to return exit status"
    method_option :debug, :type => :boolean, :aliases => ["--debug"], :default => true

    def run(*cmd)
      verify_logged_in(true)
      log_start(__method__, args, options)
      datasets = options["datasets"]
      sync_before = options["sync_before"]
      sync_after = options["sync_after"]
      log = options["log"]
      debug = options["debug"]
      title = options["title"]
      commit = options["commit"] || nil
      email_notification = options["email_notification"]
      upload_output = options["upload_output"]
      local = options["local"]
      schedule = options["schedule"]
      recurring = options["recurring"]
      image = options["image"] || nil
      grid = options["grid"]
      data = options["data"]
      data_commit = options["data_commit"]
      ignore = options["ignore"]
      sync_before_terminate = options["sync_before_terminate"]
      periodic_sync = options["periodic_sync"]
      force = options["force"]
      max_time = options["max_time"]
      dataset_only_tree = options["dataset_only_tree"]
      custom_machine = options["machine"]
      output_dir = options["output_dir"]
      data_query = options["data_query"]
      local_folders = options["local_folders"]
      prerun = options["prerun"]
      requirements = options["requirements"]
      email_notification_error = options["notify_on_error"]
      email_notification_success = options["notify_on_success"]
      emails = options["emails"]
      wait = options["wait"]

      if wait && local
        log_message("WARN: `wait` option is not valid for local experiment, ignoring it", Thor::Shell::Color::YELLOW)
        wait = false
      end


      if !data.present? and data_query.present?
        log_message("Please provide data with data_query", Thor::Shell::Color::RED)
        exit(1)
      end
      if data_query.present? and (data_commit.present? or dataset_only_tree.present?)
        log_message("Please use only one option: --query(-q) or #{data_commit.present? ? '--data_commit' : '--dataset_only_tree'} ", Thor::Shell::Color::RED)
        exit(1)
      end
      git_commit = options["git_commit"]
      git_branch = options["git_branch"]
      restart_if_stuck = options["restart_if_stuck"]

      options_hash = Hash[options]
      if local
        if Cnvrg::Helpers.windows?
            say "Windows is currently not supported for running experiments locally"
            return
        else
          invoke :exec, [cmd], :sync_before => sync_before, :sync_after => sync_after, :title => title,
                 :log => log, :email_notification => email_notification, :upload_output => upload_output,
                 :commit => commit, :image => image, :data => data, :data_commit => data_commit,
                 :ignore => ignore, :force => force, :output_dir=>output_dir, :data_query=>data_query, :local => local
          return
        end
      else
        if !periodic_sync.nil? and !periodic_sync.empty?
          if /^\d{2}$/ === periodic_sync
            if !["15","30","45","60"].include? periodic_sync
              log_message("periodic sync can only be every 15m, 30m, 45m or 60m", Thor::Shell::Color::RED)
              exit(1)
            end
          else
            log_message("periodic sync has to be one of the following values: 15m, 30m, 45m or 60m", Thor::Shell::Color::RED)
            exit(1)

          end
        end
        instances = { "small" => options["small"], "medium" => options["medium"], "large" => options["large"],
                      "gpu" => options["gpu"], "gpuxl" => options["gpuxl"], "gpuxxl" => options["gpuxxl"],
                     options["machine"] => !options["machine"].blank? }
        instance_type = get_instance_type(instances)
        invoke :exec_remote, [cmd], :sync_before => sync_before, :sync_after => sync_after, :title => title, :machine_type => instance_type,
               :schedule => schedule, :recurring => recurring, :log => log, :email_notification => email_notification, :upload_output => upload_output, :commit => commit,
               :image => image, :grid => grid, :data => data, :data_commit => data_commit, :ignore => ignore, :force => force, :sync_before_terminate => sync_before_terminate,
               :max_time => max_time,
               :periodic_sync => periodic_sync, :dataset_only_tree=> dataset_only_tree,
               :output_dir=>output_dir, :data_query=>data_query, :git_commit =>git_commit, :git_branch=> git_branch, :debug => debug,
               :restart_if_stuck =>restart_if_stuck, :local_folders => local_folders, :datasets => datasets, :prerun => prerun, :requirements => requirements,
               :email_notification_error => email_notification_error, :email_notification_success => email_notification_success, :emails => emails, :wait => wait

        return
      end
    end

    desc '', '', :hide => true
    method_option :sync_before, :type => :boolean, :aliases => ["-sb,--sync_before"], :default => true
    method_option :sync_after, :type => :boolean, :aliases => ["-sa,--sync_after"], :default => true
    method_option :title, :type => :string, :aliases => ["-t", "--title"], :default => ""
    method_option :log, :type => :boolean, :aliases => ["--log"], :default => false
    method_option :email_notification, :type => :boolean, :aliases => ["-en,--email_notification"], :default => false
    method_option :upload_output, :type => :string, :aliases => ["-uo,--upload_output"], :default => ""
    method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :default => ""
    method_option :image, :type => :string, :aliases => ["-i", "--image"], :default => ""
    method_option :indocker, :type => :boolean, :aliases => ["--indocker"], :default => false
    method_option :data, :type => :string, :aliases => ["-d", "--data"], :default => ""
    method_option :data_commit, :type => :string, :aliases => ["-dc", "--data_commit"], :default => ""
    method_option :ignore, :type => :string, :aliases => ["-i", "--ignore"], :desc => "ignore following files", :default => ""
    method_option :docker_id, :type => :string, :aliases => ["--docker_id"], :desc => "docker id to watch", :default => ""
    method_option :gpu_util_from_docker, :type => :boolean, :aliases => ["--gpu-util-from-docker"], :desc => "take gpu utilization from job docker", :default => false
    method_option :remote, :type => :boolean, :aliases => ["--remote"], :default => false
    method_option :gpu, :type => :boolean, :aliases => ["--gpu"], :default => false
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false
    method_option :sync_before_terminate, :type => :boolean, :aliases => ["-sbt", "--sync_before_terminate"], :default => false
    method_option :periodic_sync, :type => :string, :aliases => ["-ps", "--periodic_sync"], :default => ""
    method_option :output_dir, :type => :string, :aliases => ["-o", "--output_dir"], :default => nil
    method_option :data_query, :type => :string, :aliases => ["-q", "--query"], :default => nil
    method_option :use_bash, :type => :boolean, :aliases => ["-b", "--use_bash"], :default => false
    method_option :docker_stats, :type => :boolean, :aliases => ["--docker_stats"], :default => true
    method_option :local, :type => :boolean, :aliases => ["-l", "--local"], :default => false

    def exec(*cmd)
      log = []
      verify_logged_in(true)
      log_start(__method__, args, options)
      working_dir = is_cnvrg_dir
      script_path = get_cmd_path_in_dir(working_dir, Dir.pwd)

      sync_before = options["sync_before"]
      sync_after = options["sync_after"]
      print_log = options["log"]
      title = options["title"]
      commit = options["commit"] || nil
      image = options["image"] || nil
      indocker = options["indocker"] || false
      ignore = options[:ignore] || ""
      force = options[:force]
      sync_before_terminate = options["sync_before_terminate"]
      periodic_sync = options["periodic_sync"]
      email_notification = options["email_notification"]
      output_dir = options['output_dir'] || "output"
      project_home = get_project_home
      data_query = options["data_query"]
      docker_stats = options["docker_stats"]
      local = options[:local] || false
      @project = Project.new(project_home)
      if @project.is_git
        sync_before = false
      end
      # is_new_branch = @project.compare_commit(commit)
      is_new_branch = false
      begin
        if !commit.nil? and !commit.empty?
          invoke :jump, [commit], []
        else
          if sync_before
            # Sync before run
            invoke :sync, [false], :new_branch => is_new_branch, :ignore => ignore, :force => force

          end
        end
        #set image for the project
        if !image.nil? and !image.empty?
          invoke :set_image, [image]
        end
        if !indocker
          image_proj = is_project_with_docker(working_dir)
          if image_proj and image_proj.is_docker
            container = image_proj.get_container
            if !container
              log_message("Couldn't create container with image #{image_proj.image_name}:#{image_proj.image_tag}", Thor::Shell::Color::RED)
              exit(1)
            end


            exec_args = args.flatten.join(" ")
            options_hash = Hash[options]
            options_hash.except!("image", "indocker")
            exec_options = options_hash.map {|x| "--#{x[0]}=#{x[1]}"}.flatten.join(" ")
            command_to_run = copy_args.join(" ")
            command = ["/bin/bash", "-lc", "cnvrg exec --indocker #{exec_options} #{command_to_run} #{exec_args}"]
            puts container.exec(command, tty: true)
            container.stop()
            exit(0)
          end
        end
        remote = options["remote"]
        if remote
          if options["docker_id"].present?
            docker_id = options["docker_id"]
          else
            docker_id = `cat /etc/hostname`
            docker_id = docker_id.strip()
          end
        end
        is_on_gpu = options["gpu"]
        start_commit = @project.last_local_commit
        cmd = cmd.join("\s")

        @exp = Experiment.new(@project.owner, @project.slug)

        platform = RUBY_PLATFORM
        machine_name = Socket.gethostname
        machine_activity_slug = ENV["CNVRG_MACHINE_ACTIVITY"]
        begin
          @exp.start(cmd, platform, machine_name, start_commit, title, email_notification, machine_activity_slug, script_path, sync_before_terminate, periodic_sync)
          log_message("Experiment's live results: #{Cnvrg::Helpers.remote_url}/#{@project.owner}/projects/#{@project.slug}/experiments/#{@exp.slug}", Thor::Shell::Color::GREEN)
          log_message("Running: #{cmd}\n", Thor::Shell::Color::BLUE)
          unless @exp.slug.nil?
            real = Time.now
            exp_success = true
            memory_total = []
            cpu_total = []
            start_loop = Time.now
            stdout, stderr = '', ''
            begin
              process_running = true
              if docker_stats
                stats_thread = Thread.new do
                  while process_running do
                    sleep 30
                    begin
                      stats = remote ? usage_metrics_in_docker(docker_id) : Helpers.ubuntu? ? { memory: memory_usage, cpu: cpu_usage } : {}
                      if is_on_gpu
                        gu = gpu_util(take_from_docker: options["gpu_util_from_docker"], docker_id: docker_id)
                        stats['gpu_util'] = gu[0]
                        stats['gpu'] = gu[1]
                      end
                      @exp.send_machine_stats [stats] unless stats.empty?
                    rescue => e
                      log_error(e)
                      log_message("Failed to upload ongoing stats, continuing with experiment", Thor::Shell::Color::YELLOW)
                    end
                  end
                end
              end
              start_time = Time.now
              if @exp.get_cmd.present?
                cmd = @exp.get_cmd
              end

              if local
                exec_local(cmd, print_log, start_commit, real, start_time)
                exit_status = $?.exitstatus

              else
                command_slug = (0...18).map { (65 + rand(26)).chr }.join
                result_file = "/conf/result-#{command_slug}"
                data = {cmd: cmd, async: true, format: true, file_name: result_file, use_script: true, use_bash: options["use_bash"]}
                conn = Cnvrg::Helpers::Executer.get_main_conn
                response = conn.post('command', data.to_json)
                if response.to_hash[:status].to_i != 200
                  exit_status = 129
                  raise StandardError.new("Cant send command to slave")
                end
                t = FileWatch::Tail.new
                filename = result_file
                lines = []
                t.tail(filename)
                t.subscribe do |path, line|
                  begin
                    cur_log = JSON.parse(line)
                    if cur_log["type"] == "endMessage"
                      exit_status = cur_log["real"].to_i
                      break
                    else
                      puts(cur_log.to_json)
                      STDOUT.flush
                      cur_log["time"] = Time.parse(cur_log["timestamp"])
                      cur_log["message"] = cur_log["message"].to_s + "\r\n"
                      log << cur_log
                    end
                    if log.size >= 10
                      @exp.upload_temp_log(log)
                      log = []
                    elsif (start_time + 15.seconds) <= Time.now
                      @exp.upload_temp_log(log) unless log.empty?
                      log = []
                      start_time = Time.now
                    end
                  rescue => e
                    log_error(e)
                  end
                end
              end
              end_time = Time.now
              process_running = false

              if !log.empty?

                temp_log = log
                @exp.upload_temp_log(temp_log)
                log -= temp_log
              end

              cpu_average = cpu_total.inject(0) {|sum, el| sum + el}.to_f / cpu_total.size
              memory_average = memory_total.inject(0) {|sum, el| sum + el}.to_f / memory_total.size
              if exit_status != 0
                exp_success = false
              end

              if sync_after
                @exp.job_log(["Syncing Experiment"])
              # Sync after run
                if @project.is_git
                  output_dir = output_dir || @exp.output_dir
                  if output_dir.present?
                    upload(false, false, true, ignore, true, false, output_dir, "Experiment", @exp.slug, true )
                  end
                else
                  upload(false, false, true, ignore, true, false, nil, "Experiment", @exp.slug, true )
                end
              end

              end_commit = @project.last_local_commit

                # log_thread.join
              stats_thread.join if docker_stats

                res = @exp.end(log, exit_status, end_commit, cpu_average, memory_average, end_time: end_time)


                if !exp_success

                  log_message("Experiment has failed, look at the log for more details or run cnvrg exec --log", Thor::Shell::Color::RED)
                else
                  check = Helpers.checkmark()
                  log_message("#{check} Done. Experiment's results were updated!", Thor::Shell::Color::GREEN)
                end

            rescue => e
              if container
                container.stop()
              end
              log_message("Couldn't run #{cmd}, check your input parameters", Thor::Shell::Color::RED)
              if @exp
                # log_thread.join
                Thread.kill(stats_thread) if docker_stats
                if exit_status.blank?
                  exit_status = "-1"
                end
                res = @exp.end(log, exit_status, end_commit, cpu_average, memory_average)

              end
              log_error(e)
              # Thread.kill(log_thread)
              # Thread.kill(stats_thread)

              exit(1)
            end
          end

        end
      rescue SignalException
        exit_status = -1
        end_commit = @project.last_local_commit
        process_running = false
        # log_thread.join
        stats_thread.join if docker_stats

        res = @exp.end(log, exit_status, end_commit, cpu_average, memory_average)
        if container
          container.stop()
        end
        say "\nAborting"

        exit(1)
      end
    end
    desc '', '', :hide => true
    method_option :sync_before, :type => :boolean, :aliases => ["-sb", "--sync_before"], :default => true
    method_option :sync_after, :type => :boolean, :aliases => ["-sa", "--sync_after"], :default => true
    method_option :title, :type => :string, :aliases => ["-t", "--title"], :default => ""
    method_option :log, :type => :boolean, :aliases => ["--log"], :default => false
    method_option :email_notification, :type => :boolean, :aliases => ["-en", "--email_notification"], :default => false
    method_option :upload_output, :type => :string, :aliases => ["-uo", "--upload_output"], :default => ""
    method_option :machine_type, :type => :string, :default => ""
    method_option :schedule, :type => :string, :aliases => ["--schedule"], :default => ""
    method_option :recurring, :type => :string, :aliases => ["--recurring"], :default => ""
    method_option :commit, :type => :string, :aliases => ["-c, --commit"], :default => nil
    method_option :image, :type => :string, :aliases => ["-i", "--image"], :default => ""
    method_option :grid, :type => :string, :aliases => ["-g", "--grid"], :default => ""
    method_option :data, :type => :string, :aliases => ["-d", "--data"], :default => ""
    method_option :data_commit, :type => :string, :aliases => ["--data_commit"], :default => ""
    method_option :ignore, :type => :string, :aliases => ["-i", "--ignore"], :desc => "ignore following files", :default => ""
    method_option :force, :type => :boolean, :aliases => ["-f", "--force"], :default => false
    method_option :max_time, :type => :string, :aliases => [ "--max_time"], :default => nil
    method_option :dataset_only_tree, :type => :boolean, :aliases => [ "--dataset_only_tree"], :default => false
    method_option :periodic_sync, :type => :string, :aliases => ["-ps", "--periodic_sync"], :default => nil
    method_option :sync_before_terminate, :type => :boolean, :aliases => ["-sbt", "--sync_before_terminate"], :default => false
    method_option :output_dir, :type => :string, :aliases => ["-o", "--output_dir"], :default => nil
    method_option :data_query, :type => :string, :aliases => ["-q", "--query"], :default => nil
    method_option :git_commit, :type => :string, :aliases => [ "--git_commit"], :default => nil
    method_option :git_branch, :type => :string, :aliases => [ "--git_branch"], :default => nil
    method_option :restart_if_stuck, :type => :boolean, :aliases => ["--restart"], :default => nil
    method_option :local_folders, :type => :string, :aliases => ["--local_folders"], :default => nil
    method_option :datasets, :type => :string, :aliases => ["--datasets"], :default => nil
    method_option :prerun, :type => :boolean, :aliases => ["-p", "--prerun"], :default => true
    method_option :requirements, :type => :boolean, :aliases => ["-r", "--requirements"], :default => true
    method_option :email_notification_error, :type => :boolean, :aliases => ["-noe", "--email_notification_error"], :default => true
    method_option :email_notification_success, :type => :boolean, :aliases => ["-nos", "--email_notification_success"], :default => true
    method_option :emails, :type => :string, :aliases => ["-es", "--emails"], :default => "", :desc => "additional emails to notify on success / or error"
    method_option :wait, :type => :boolean, :aliases => ["-w", "--wait"], :default => false, :desc => "keep command session open until experiment finished to return exit status"
    method_option :debug, :type => :boolean, :aliases => ["--debug"], :default => true

    def exec_remote(*cmd)

      verify_logged_in(true)
      log_start(__method__, args, options)
      working_dir = is_cnvrg_dir
      path_to_cmd = get_cmd_path_in_dir(working_dir, Dir.pwd)

      begin
        title = options["title"] || nil
        grid = options["grid"] || nil
        data = options["data"] || nil
        datasets = options["datasets"] || nil
        data_commit = options["data_commit"] || nil
        data_query = options["data_query"] || nil
        sync_before = options["sync_before"]
        force = options["force"]
        debug = options["debug"]
        prerun = options["prerun"]
        requirements = options["requirements"]
        email_notification_error = options["email_notification_error"]
        email_notification_success = options["email_notification_success"]
        emails = options["emails"]
        max_time = options["max_time"]
        if !max_time.nil? and !max_time.empty?
          max_time = max_time.to_i
          if max_time <=0
            log_message("Max time for experiment should be more than 0 minutess", Thor::Shell::Color::RED)
            exit(1)
          end
        end
        periodic_sync = options["periodic_sync"]
        sync_before_terminate = options["sync_before_terminate"]
        dataset_only_tree = options["dataset_only_tree"]
        ds_sync_options = 0
        if dataset_only_tree
          ds_sync_options = 1
        end
        restart_if_stuck = options["restart_if_stuck"]
        instance_type = options["machine_type"] || nil
        schedule = options["schedule"] || ""
        recurring = options["recurring"] || ""
        upload_output = options["upload_output"]
        time_to_upload = calc_output_time(upload_output)
        if time_to_upload == 0 or time_to_upload == -1
          upload_output_option = "--upload_output=1m"
        else
          upload_output_option = "--upload_output=#{upload_output}"
        end
        remote = "--remote=true"
        if !instance_type.nil? and instance_type.include? "gpu"
          remote = "#{remote} --gpu=true"
        end

        output_dir = options["output_dir"] || nil
        git_commit = options["git_commit"]
        git_branch = options["git_branch"]
        options_hash = Hash[options]
        local_folders_options = options["local_folders"]
        options_hash.except!("schedule", "recurring", "machine_type", "image", "upload_output", "grid", "data", "data_commit", "title",
                             "local", "small", "medium", "large", "gpu", "gpuxl", "gpuxxl","max_time","dataset_only_tree",
                             "data_query", "git_commit","git_branch","restart_if_stuck","local_folders","output_dir", "commit", "datasets",
                             "requirements", "prerun", "email_notification_error", "email_notification_success", "emails", "wait","debug")
        exec_options = options_hash.map {|x| "--#{x[0]}=#{x[1]}"}.flatten.join(" ")
        command = "#{exec_options} #{remote}  #{upload_output_option} #{cmd.flatten.join(" ")}"
        commit_to_run = options["commit"] || nil
        if !schedule.nil? and !schedule.empty?

          local_timestamp = get_schedule_date

        end
        project = Project.new(working_dir)

        if project.is_git and output_dir.blank?
          output_dir  = "output"
        end
        image = options["image"] || nil
        forced_commit = nil
        if sync_before and !project.is_git
          if force
          sync_result = invoke :sync, [false], :force => force, :return_id=> true
          begin
            forced_commit = JSON(sync_result)["commit_sha1"]
          rescue
            forced_commit = nil
          end
          else
            sync_result = invoke :sync, [false], :force => false
          end
        end
        #handle grid if it's git project
        if project.is_git and grid.present?
          if !File.exist? "#{project.local_path}/#{grid}"
            log_message("Hyper Search File:#{grid} couldn't be found", Thor::Shell::Color::RED)
            return
          end
          grid_content  = YAML.load_file("#{project.local_path}/#{grid}")
          if grid_content.present?
            grid = grid_content
          else
            log_message("Hyper Search file:#{grid} has no content", Thor::Shell::Color::RED)
            return
          end
        end

        log_message("Running remote experiment", Thor::Shell::Color::BLUE)
        exp = Experiment.new(project.owner, project.slug)
        if forced_commit and (commit_to_run.nil? or commit_to_run.empty?)
          commit_to_run = forced_commit
        end

        commit_to_run = commit_to_run.presence || project.last_local_commit

        res = exp.exec_remote(command, commit_to_run, instance_type, image, schedule, local_timestamp, grid, path_to_cmd, data, data_commit,
                              periodic_sync, sync_before_terminate, max_time, ds_sync_options,output_dir,
                              data_query, git_commit, git_branch,debug, restart_if_stuck,local_folders_options, title, datasets, prerun: prerun, requirements: requirements, recurring: recurring,
                              email_notification_error: email_notification_error, email_notification_success: email_notification_success, emails_to_notify: emails)
        if Cnvrg::CLI.is_response_success(res)
          check = Helpers.checkmark()
          str = "#{check} Experiment's is on: #{Cnvrg::Helpers.remote_url}/#{project.owner}/projects/#{project.slug}/experiments/#{res["result"]["exp_url"]}"

          if res["result"]["grid"]
            str = "Running grid search, follow here: #{Cnvrg::Helpers.remote_url}/#{project.owner}/projects/#{project.slug}/experiments?grid=#{res["result"]["exp_url"]}"
          end

          log_message(str, Thor::Shell::Color::GREEN)

          exit_status = 0

          if options['wait']
            end_pos = 0
            while true
              tries = 0
              begin
                result = fetch_experiment_info(res,project,end_pos)

                exit_statuses = result.values.pluck('exit_status')
                if exit_statuses.include? nil
                  if res["result"]["grid"]
                    system("clear") || system("cls")
                    msg = "#{Time.current}: waiting for all experiments to finish"
                    puts msg
                  else
                    end_pos = result[res['result']['exp_url']]['end_pos']
                    logs = result[res['result']['exp_url']]['logs']
                    logs.each do |log|
                      puts log['message']
                    end
                  end
                  sleep 3
                else
                  result.each do |slug, value|
                    exit_status = value['exit_status']
                    puts "Experiment #{slug} was exited with status #{exit_status}"
                  end
                  break
                end
              rescue => e
                log_error(e)
                log_message("Error occurred, retrying", Thor::Shell::Color::RED)
                sleep 3
                tries += 1
                retry if tries <= 5
                exit(1)
              end
            end
          end

          exit(exit_status.to_i)
        end
      rescue => e
        log_message("Error occurred, Aborting", Thor::Shell::Color::RED)
        log_error(e)

      rescue SignalException
        exit_status = -1
        end_commit = project.last_local_commit
        sleep(20) # end cycle

        res = @exp.end(log, exit_status, end_commit, "", "")
        say "\nAborting"

        exit(1)
      end
    end

    desc 'deploy', 'Deploys model to production', :hide => true
    method_option :small, :type => :boolean, :aliases => ["-s", "--small"], :default => false
    method_option :medium, :type => :boolean, :aliases => ["-m", "--medium"], :default => false
    method_option :large, :type => :boolean, :aliases => ["-l", "--large"], :default => false
    method_option :gpu, :type => :boolean, :aliases => ["--gpu"], :default => false
    method_option :gpuxl, :type => :boolean, :aliases => ["--gpuxl"], :default => false
    method_option :gpuxxl, :type => :boolean, :aliases => ["--gpuxxl"], :default => false
    method_option :schedule, :type => :string, :aliases => ["--schedule"], :default => ""
    method_option :commit, :type => :string, :aliases => ["--commit", "-c"], :default => ""
    method_option :workers, :type => :string, :aliases => ["--workers", "-w"], :default => ""
    method_option :file_as_input, :type => :boolean, :aliases => ["--input", "-i"], :default => false
    method_option :title, :type => :string, :aliases => ["--title", "-t"], :default => ""
    def deploy(file_to_run, function)
      verify_logged_in(true)
      log_start(__method__, args, options)
      working_dir = is_cnvrg_dir
      begin
        instances = {"small" => options["small"], "medium" => options["medium"], "large" => options["large"],
                     "gpu" => options["gpu"], "gpuxl" => options["gpuxl"], "gpuxxl" => options["gpuxxl"]}
        instance_type = get_instance_type(instances)

          schedule = options["schedule"] || ""
          title = options['title']

          if !schedule.nil? and !schedule.empty?
            local_timestamp = get_schedule_date
          end
          project = Project.new(working_dir)
          commit_to_run = options["commit"] || nil

        workers = options["workers"] || nil
        begin
          num_workers = workers.to_i
        rescue
          log_message("Number of workers should be a number between 1 to 10", Thor::Shell::Color::RED)
          exit(1)
        end
        file_as_input = options["file_as_input"] || false


        image = is_project_with_docker(working_dir)
        image_slug = 'cnvrg'


        invoke :sync, [false], []

          res = project.deploy(file_to_run, function, nil, commit_to_run, instance_type, image_slug, schedule, local_timestamp, num_workers, file_as_input, title)

        if Cnvrg::CLI.is_response_success(res)

            check = Helpers.checkmark()
            log_message("#{check} Deployment process is on: #{Cnvrg::Helpers.remote_url}/#{project.owner}/projects/#{project.slug}/endpoints/show/#{res["result"]["deploy_slug"]}", Thor::Shell::Color::GREEN)

          exit(0)
          # end
        end
      rescue => e
        log_message("Error occurred, Aborting", Thor::Shell::Color::RED)
        log_error(e)


      rescue SignalException
        exit_status = -1
        end_commit = project.last_local_commit
        sleep(20) # end cycle

        res = @exp.end(log, exit_status, end_commit, "", "")
        say "\nAborting"

        exit(1)
      end
    end

    method_option :kernel, :type => :string, :aliases => ["--k", "-k"], :default => ""
    method_option :notebook_dir, :type => :string, :aliases => ["-n", "--n"], :default => "", :desc => "relative path to notebook dir from current directory"
    method_option :local, :type => :boolean, :aliases => ["-l"], :default => false
    method_option :small, :type => :boolean, :aliases => ["-sm", "--small"], :default => false
    method_option :medium, :type => :boolean, :aliases => ["-md", "--medium"], :default => false
    method_option :datasets, :type => :string, :aliases => ["--datasets"], :desc => "'[{\"id\": \"dataset id\", \"commit\": \"commit id\", \"query\": \"query name\", \"tree_only\": true]'", :default => ""
    method_option :large, :type => :boolean, :aliases => ["-lg", "--large"], :default => false
    method_option :gpu, :type => :boolean, :aliases => ["--gpu"], :default => false
    method_option :gpuxl, :type => :boolean, :aliases => ["--gpuxl"], :default => false
    method_option :gpuxxl, :type => :boolean, :aliases => ["--gpuxxl"], :default => false
    method_option :image, :type => :string, :aliases => ["-i", "--image"], :default => nil
    method_option :data, :type => :string, :aliases => ["-d", "--data"], :default => ""
    method_option :data_commit, :type => :string, :aliases => ["--data_commit"], :default => ""
    method_option :dataset_only_tree, :type => :boolean, :aliases => [ "--dataset_only_tree"], :default => false
    method_option :data_query, :type => :string, :aliases => ["-q", "--query"], :default => ""

    desc 'notebook', 'Starts a notebook session remotely or locally', :hide => true

    def notebook
      verify_logged_in(true)
      log_start(__method__, args, options)
      local = options["local"]
      notebook_dir = options["notebook_dir"]
      datasets = options["datasets"]
      kernel = options["kernel"]
      image = options["image"] || nil
      data = options["data"]
      data_commit = options["data_commit"]
      dataset_only_tree = options["dataset_only_tree"]
      data_query = options["data_query"]
      if !data.present? and data_query.present?
        log_message("Please provide data with data_query", Thor::Shell::Color::RED)
        exit(1)
      end
      if data_query.present? and (data_commit.present? or dataset_only_tree.present?)
        log_message("Please use only one option: --query(-q) or #{data_commit.present? ? '--data_commit' : '--dataset_only_tree'} ", Thor::Shell::Color::RED)
        exit(1)
      end

      if local
        invoke :run_notebook, [], :notebook_dir => notebook_dir, :remote => false, :kernel => kernel, :image => image
        return
      else
        instances = {"small" => options["small"], "medium" => options["medium"], "large" => options["large"],
                     "gpu" => options["gpu"], "gpuxl" => options["gpuxl"], "gpuxxl" => options["gpuxxl"]}
        instance_type = get_instance_type(instances)

        invoke :remote_notebook, [], :notebook_dir => notebook_dir, :kernel => kernel, :machine_type => instance_type, :image => image,
               :data => data, :data_commit => data_commit , :dataset_only_tree => dataset_only_tree, :data_query => data_query, :datasets => datasets
        return

      end


    end

    desc '', '', :hide => true
    method_option :notebook_dir, :type => :string, :aliases => ["-n"], :default => "", :desc => "relative path to notebook dir from current directory"
    method_option :machine_type, :type => :string, :default => ""
    method_option :kernel, :type => :string, :aliases => ["--kernel", "-k"], :default => ""
    method_option :image, :type => :string, :aliases => ["-i"], :default => ""
    method_option :data, :type => :string, :aliases => ["-d", "--data"], :default => ""
    method_option :data_commit, :type => :string, :aliases => ["--data_commit"], :default => ""
    def remote_notebook_old()
      verify_logged_in(true)
      log_start(__method__, args, options)

      working_dir = is_cnvrg_dir()
      notebook_dir = options["notebook_dir"]
      instance_type = options["machine_type"] || nil
      kernel = options["kernel"] || nil
      data = options["data"]
      data_commit = options["data_commit"]


      begin
        choose_image = options["image"]

        if !choose_image.nil? and !choose_image.empty?
          invoke :set_image, [choose_image]
        end
        invoke :sync, [false], []


        res = @image.remote_notebook(notebook_dir, instance_type, kernel, data, data_commit)
        if Cnvrg::CLI.is_response_success(res)
          if res["result"]["machine"] == -1
            log_message("There are no available machines", Thor::Shell::Color::BLUE)
            create = yes? "create new machine?", Thor::Shell::Color::YELLOW
            if create
              res = Cnvrg::API.request("users/#{@image.owner}/machines/list", 'GET')
              if Cnvrg::CLI.is_response_success(res)
                instance_type = machine_options(res["result"]["aws_options"])
                if @image.new_machine(instance_type)
                  res = @image.remote_notebook(notebook_dir, instance_type, kernel)
                  if Cnvrg::CLI.is_response_success(res)
                    url = res["result"]["url"]
                    if !url.nil? and !url.empty?
                      check = Helpers.checkmark()

                      log_message("#{check} Notebook server started successfully: #{url}", Thor::Shell::Color::GREEN)
                    else
                      log_message("Couldn't run notebook server", Thor::Shell::Color::RED)
                    end
                    exit(0)
                  end
                end
              else
                log_message("No machines are avilable", Thor::Shell::Color::RED)
                exit(0)
              end


            else
              log_message("Can't execute command on remote machine with local image", Thor::Shell::Color::RED)
              exit(1)

            end
          else
            note_url = res["result"]["notebook_url"]
            @image.set_note_url(note_url)
            check = Helpers.checkmark()
            log_message("#{check} Notebook is on: #{Cnvrg::Helpers.remote_url}/#{@image.owner}/projects/#{@image.project_slug}/notebook_sessions/show/#{note_url}", Thor::Shell::Color::GREEN)
            # Launchy.open(url)

            exit(0)
          end
        end
      rescue => e
        log_message("Error occurred, Aborting", Thor::Shell::Color::RED)
        log_error(e)

      rescue SignalException
        exit_status = -1
        end_commit = @project.last_local_commit

        res = @exp.end(log, exit_status, end_commit, cpu_average, memory_average)
        say "\nAborting"

        exit(1)
      end
    end

    desc 'remote_notebook', 'Run notebook server on remote server', :hide => true
    method_option :machine_type, :type => :string, :default => ""
    method_option :notebook_type, :type => :string, :aliases => ["-n", "--notebook_type"], :default => ""
    method_option :data, :type => :string, :aliases => ["-d", "--data"], :default => ""
    method_option :data_commit, :type => :string, :aliases => ["--data_commit"], :default => ""
    method_option :commit, :type => :string, :aliases => ["--commit"], :default => ""
    method_option :dataset_only_tree, :type => :boolean, :aliases => [ "--dataset_only_tree"], :default => false
    method_option :data_query, :type => :string, :aliases => ["-q","--data_query"], :default => ""
    method_option :image, :type => :string, :aliases => ["--image"], :default => nil
    method_option :datasets, :type => :string, :aliases => ["--datasets"], :desc => "'[{\"id\": \"dataset id\", \"commit\": \"commit id\", \"query\": \"query name\", \"tree_only\": true]'", :default => ""

    def remote_notebook()
      verify_logged_in(true)
      log_start(__method__, args, options)

      working_dir = is_cnvrg_dir()
      instance_type = options["machine_type"] || nil
      datasets = options["datasets"]
      data = options["data"]
      data_commit = options["data_commit"]
      commit = options["commit"]
      notebook_type = options["notebook_type"]
      dataset_only_tree = options["dataset_only_tree"]
      image = options["image"]
      ds_sync_options = 0
      if dataset_only_tree
        ds_sync_options = 1
      end

      data_query = nil
      if data.present?
        data_query = options["data_query"]
      end

      if data_commit.present? and data_query.present?
        log_message("Please use only one option: --query(-q) or --data_commit ", Thor::Shell::Color::RED)
        exit(1)
      end

      begin
        project = Project.new(working_dir)
        exp = Experiment.new(project.owner, project.slug)

        if !notebook_type.nil? and !notebook_type.empty?
          notebook_type = "jupyter"
        end
        invoke :sync, [false], []
        slug = ""
        res = exp.remote_notebook(instance_type, commit, data, data_commit, notebook_type,ds_sync_options,data_query, image, datasets)
        if Cnvrg::CLI.is_response_success(res)
          slug = res["result"]["notebook_url"]
          log_message("#{Helpers.checkmark} Notebook is ready: #{Cnvrg::Helpers.remote_url}/#{project.owner}/projects/#{project.slug}/notebook_sessions/show/#{slug}", Thor::Shell::Color::GREEN)

        end
      rescue => e
        log_message("Error occurred, Aborting", Thor::Shell::Color::RED)
        log_error(e)

      rescue SignalException
        log_message("Aborting", Thor::Shell::Color::BLUE)
        notebook_stop(slug) unless slug.nil? or slug.empty?

        exit(1)
      end
    end

    desc 'search_libraries', 'search if  libraries installed', :hide => true

    def search_libraries(library)
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        project_dir = is_cnvrg_dir()

        image = is_project_with_docker(project_dir)
        if image and image.is_docker
          container = image.get_container
          if !container
            say "Couldn't create container with image #{image.image_name}:#{image.image_tag}", Thor::Shell::Color::RED
            exit(1)
          end
        else
          say "Project is not configured with any image", Thor::Shell::Color::RED
          exit(1)

        end

        say "Searching for #{library}", Thor::Shell::Color::BLUE
        pip_arr = image.get_installed_packages("python")
        pip_arr = pip_arr.map(&:downcase)
        check = Helpers.checkmark()
        if !(p = pip_arr.map {|x| x.split("==")[0]}.index(library.downcase)).nil?

          say "#{check} Found it!", Thor::Shell::Color::GREEN


          printf "%-40s %-30s\n", "#{pip_arr[p].split("==")[0]}", "#{pip_arr[p].split("==")[1]}"

        else
          dpkg_arr = image.get_installed_packages("system")
          dpkg_arr = dpkg_arr.map(&:downcase)
          if !(p = dpkg_arr.map {|x| x.split("==")[0]}.index(library.downcase)).nil?
            say "#{check} Found!", Thor::Shell::Color::GREEN

            printf "%-40s %-30s\n", "#{dpkg_arr[p].split("==")[0]}", "#{dpkg_arr[p].split("==")[1]}"
          else
            say "Couldn't find #{library}, run cnvrg install_libraries to install", Thor::Shell::Color::RED
            exit(1)
          end


        end
      rescue => e
        log_end(-1, e.message)
        say "Error occurred, aborting", Thor::Shell::Color::RED
        if container
          container.stop()
        end
      rescue SignalException
        log_end(-1)
        if container
          container.stop()
        end
        say "Aborting"
        exit(1)
      end
    end

    desc 'show_libraries', 'show system libraries installed', :hide => true
    method_option :system, :type => :boolean, :aliases => ["-s", "--s"], :default => false, :desc => "show also system libraries installed"

    def show_libraries
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        system = options["system"] || false


        project_dir = is_cnvrg_dir()

        image = is_project_with_docker(project_dir)
        if image and image.is_docker
          container = image.get_container
          if !container
            say "Couldn't create container with image #{image.image_name}:#{image.image_tag}", Thor::Shell::Color::RED
            exit(1)
          end
        else
          say "Project is not configured with any image", Thor::Shell::Color::RED
          exit(1)

        end

        say "Showing python installed libraries", Thor::Shell::Color::BLUE
        pip_arr = image.get_installed_packages("python")
        printf "%-40s %-30s\n", "name", "version"
        printf "%-40s %-30s\n", "====", "======="

        pip_arr.each do |p|

          printf "%-40s %-30s\n", "#{p.split("==")[0]}", "#{p.split("==")[1]}"
        end
        if system

          say "Showing system installed libraries", Thor::Shell::Color::BLUE
          dpkg_arr = image.get_installed_packages("system")
          printf "%-40s %-30s\n", "name", "version"
          printf "%-40s %-30s\n", "====", "======="
          dpkg_arr.each do |p|
            printf "%-40s %-30s\n", "#{p.split("==")[0]}", "#{p.split("==")[1]}"

          end
        end
      rescue => e
        log_end(-1, e.message)
        say "Error occurred, aborting"
        if container
          container.stop()
        end
      rescue SignalException
        log_end(-1)
        say "Aborting"
        exit(1)
      end
    end


    desc 'run_notebook', 'Starts a new notebook environment', :hide => true
    method_option :notebook_dir, :type => :string, :aliases => ["-n", "--n"], :default => "", :desc => "relative path to notebook dir from current directory"
    method_option :remote, :type => :boolean, :aliases => ["-r", "--r"], :default => false, :desc => "run on remote machine"
    method_option :kernel, :type => :string, :aliases => ["-k", "--k"], :default => "", :desc => "default kernel"
    method_option :verbose, :type => :boolean, :aliases => ["--v"], :default => false
    method_option :image, :type => :string, :aliases => ["-i"], :default => ""

    def run_notebook

      begin
        verify_logged_in(true)
        log_start(__method__, args, options)

        project_dir = is_cnvrg_dir()

        notebook_dir = options["notebook_dir"]
        remote = options["remote"] || false
        kernel = options["kernel"] || ""
        notebooks_pid = nil

        if notebook_dir.empty?
          notebook_dir = project_dir
        else

          notebook_dir = project_dir + notebook_dir
        end
        choose_image = options["image"]

        if !choose_image.nil? and !choose_image.empty?
          invoke :set_image, [choose_image]
        end

        image = is_project_with_docker(Dir.pwd)
        if !image
          jupyter_installed = `which jupyter`
          if !$?.success?
            say "Could not find jupyter, Is it installed?", Thor::Shell::Color::RED
            exit(1)
          end


          cmd = "jupyter-notebook --port=8888"
          PTY.spawn(cmd) do |stdout, stdin, pid, stderr|
            begin
              notebooks_pid = pid
              stdout.each do |line|
                puts line

              end

            rescue Errno::EIO => e
              # break
            rescue Errno::ENOENT
              log_end(1, "command #{cmd} isn't valid")


              say "command \"#{cmd}\" couldn't be executed, verify command is valid", Thor::Shell::Color::RED
            rescue PTY::ChildExited
              log_end(1, "proccess exited")
              say "The process exited!", Thor::Shell::Color::RED
            rescue => e
              log_end(-1, e.message)
              say "Error occurred,aborting", Thor::Shell::Color::RED
              exit(0)

            end


          end

        end

        if image and image.is_docker and !remote
          container = image.get_container
          if !container
            say "Couldn't start docker container", Thor::Shell::Color::RED
            exit(1)

          end

          if options["verbose"]
            say "Syncing project before running", Thor::Shell::Color::BLUE
            say 'Checking for new updates from remote version', Thor::Shell::Color::BLUE
          end
          @project = Project.new(project_dir)

          start_commit = @project.last_local_commit

          if (note_slug = image.note_slug)
            say "There is a running notebook session in: https://cnvrg.io/#{@project.owner}/projects/#{@project.slug}/notebook_sessions/show/#{note_slug}", Thor::Shell::Color::BLUE
            new = yes? "Create a new session?", Thor::Shell::Color::YELLOW
            if !new
              exit(0)
            end

          end
          invoke :sync, [false], :verbose => options["verbose"]
          say "Done Syncing", Thor::Shell::Color::BLUE if options["verbose"]
          #replace url
          base_url = get_base_url()

          local_url = "/#{@project.owner}/projects/#{@project.slug}/notebook_sessions/view/local"
          command = ["/bin/bash", "-lc", "sed -i 's#c.NotebookApp.base_url = .*#c.NotebookApp.base_url = \"#{local_url}\"#' /home/ds/.jupyter/jupyter_notebook_config.py"]
          container.exec(command, tty: true)
          container.stop()
          container.start()
          sleep(7)
          @note = Experiment.new(@project.owner, @project.slug)
          port = image.container_port()

          command = ["/bin/bash", "-lc", "jupyter notebook list"]
          list = container.exec(command, tty: true)[0]
          if list.empty? or list.nil?
            say "Couldn't start notebook server", Thor::Shell::Color::RED
            log_end(1, "can't start notebook server")
            exit(1)
          end

          result = ""
          list.each do |r|
            if r.include? "http"
              result = r
            end
          end
          token = result.to_s.split("::")[0].to_s.match(/(token=)(.+)\s/)[2]

          # machine_activity = @note.get_machine_activity(project_dir)


          slug = @note.start_notebook_session(kernel, start_commit, token, port, false, notebook_dir)
          image.set_note_url(slug)
          note_url = "http://localhost:#{port}/#{@project.owner}/projects/#{@project.slug}/notebook_sessions/view/local/?token=#{token}"


          if !note_url.empty?
            check = Helpers.checkmark()

            say "#{check} Notebook server started successfully: #{note_url}", Thor::Shell::Color::GREEN
          else
            say "Couldn't start notebook server", Thor::Shell::Color::RED
            log_end(1, "can't start notebook server")
            exit(1)
          end
        end


      rescue => e
        log_end(-1, e.message)
        say "Error occurred, aborting", Thor::Shell::Color::RED
        if container
          container.stop()
        end
      rescue SignalException
        if !notebooks_pid.nil?
          ::Process.kill(0, notebooks_pid)
          say "#{check} Notebook has stopped successfully", Thor::Shell::Color::GREEN


          invoke :sync, [false], []
        else
          log_end(-1)

          if container
            container.stop()
          end
        end

      end


    end

    desc 'notebook_stop', 'Stop notebook', :hide => true
    method_option :notebook_dir, :type => :string, :aliases => ["-n", "--n"], :default => "", :desc => "relative path to notebook dir from current directory"
    method_option :remote, :type => :boolean, :aliases => ["-r", "--r"], :default => false, :desc => "run on remote machine"
    method_option :verbose, :type => :boolean, :aliases => ["--v"], :default => false

    def notebook_stop(notebook_slug)
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        project_dir = is_cnvrg_dir()


        @project = Project.new(project_dir)


        @note = Experiment.new(@project.owner, @project.slug)
        log_message("Stoping notebook session: #{notebook_slug}", Thor::Shell::Color::BLUE)

        res = @note.end_notebook_session(notebook_slug)
        if res
          check = Helpers.checkmark()
          log_message("#{check} Notebook session has stopped successfully", Thor::Shell::Color::GREEN)

          exit(0)
        else

          log_message("Couldn't stop notebook session, try stopping via cnvrg web", Thor::Shell::Color::RED)
          exit(1)
        end
      rescue => e
        log_message("Error occurd, aborting", Thor::Shell::Color::RED)
        log_error(e)
      rescue SignalException
        log_message("Aborting", Thor::Shell::Color::BLUE)
        exit(1)
      end


    end


    desc 'install_system_libraries', 'Install libraries', :hide => true

    def install_system_libraries(*command_to_run)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        image = is_project_with_docker(Dir.pwd)
        if image and image.is_docker
          container = image.get_container
          if !container

            say "Couldn't create container with image #{image.image_name}:#{image.image_tag}", Thor::Shell::Color::RED
            exit(1)
          end
        else
          say "Project is not configured with any image", Thor::Shell::Color::RED
          exit(1)

        end

        command_to_run = command_to_run.join(" ")
        say "Running #{command_to_run} in container", Thor::Shell::Color::BLUE
        command = ["/bin/bash", "-lc", "#{command_to_run}"]
        res = container.exec(command, tty: false)
        say res[0].join("\n")
        checks = Helpers.checkmark()
        say "Updating image", Thor::Shell::Color::BLUE

        image.create_custom_image("")
        say "#{checks} Done, installing libraries completed", Thor::Shell::Color::GREEN
        container.stop()

        log_end(0)
      rescue => e
        log_end(-1, e.message)
        say "Error occurred, aborting"
        if container
          container.stop()
        end
      rescue SignalException
        log_End(-1)
        if container
          container.stop()
        end
        say "\nAborting"
        exit(1)
      end

    end

    desc 'install_libraries', 'Install libraries', :hide => true
    method_option :requirement, :type => :string, :aliases => ["-r", "--r"], :default => "", :desc => "Install from the given requirements file"

    def install_python_libraries(*lib)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        image = is_project_with_docker(Dir.pwd)
        if image and image.is_docker
          container = image.get_container
          if !container

            say "Couldn't create container with image #{image.image_name}:#{image.image_tag}", Thor::Shell::Color::RED
            exit(1)
          end
        else
          say "Project is not configured with any image", Thor::Shell::Color::RED
          exit(1)

        end
        req_file = options["requirement"] || nil
        if lib.nil? and not req_file.nil?
          if not File.exist? req_file
            say "Couldn't find #{req_file}", Thor::Shell::Color::RED
            exit(1)

          end
          command_to_run = "pip install -r #{req_file}"

        else
          command_to_run = lib.join(" ")

        end
        say "Running #{command_to_run} in container", Thor::Shell::Color::BLUE
        command = ["/bin/bash", "-lc", "#{command_to_run}"]
        res = container.exec(command, tty: false)
        say res[0].join("\n")
        checks = Helpers.checkmark()
        say "Updating image", Thor::Shell::Color::BLUE

        image.create_custom_image("")
        say "#{checks} Done, installing libraries completed", Thor::Shell::Color::GREEN
        container.stop()

        log_end(0)
      rescue => e
        log_end(-1, e.message)
        say "Error occurred, aborting"
        if container
          container.stop()
        end
      rescue SignalException
        if container
          container.stop()
        end
        say "\nAborting"
        exit(1)
      end

    end


    desc 'build', 'run commands inside containers', :hide => true
    method_option :install, :type => :string, :aliases => ["--i"], :default => nil, :desc => "Install from the given instructions file"

    def build(*cmd)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        working_dir = is_cnvrg_dir
        install_file = options["install"] || nil
        if !install_file.nil?
          commands = File.open(install_file).read.chop.gsub!("\n", ",").split(",")

        else
          commands = [cmd.join(" ")]
        end


        image = is_project_with_docker(working_dir)
        if image and image.is_docker
          container = image.get_container
          if !container

            say "Couldn't create container with image #{image.image_name}:#{image.image_tag}", Thor::Shell::Color::RED
            exit(1)
          end
        else
          say "Project is not configured with any image", Thor::Shell::Color::RED
          exit(1)

        end
        commands.each do |c|
          if c.include? "pip"
            c.sub("pip", "/opt/ds/bin/pip")
          end
          if c.include? "pip3"
            c.sub("pip3", "/opt/ds3/bin/pip3")
          end

          say "Running #{c}", Thor::Shell::Color::BLUE
          command = ["/bin/bash", "-lc", "#{c}"]
          res = container.exec(command, tty: false)
          if res[2] != 0
            say "Could not run command: #{c}, #{res[1][0]}", Thor::Shell::Color::RED
            container.stop()
            log_end(0)

            exit(1)
          end
          say res[0].join("\n")
          image.store_image_build_commands(working_dir, c)
        end

        checks = Helpers.checkmark()
        say "Updating image", Thor::Shell::Color::BLUE
        # image.create_custom_image("",working_dir)
        container.stop()
        say "#{checks} Done", Thor::Shell::Color::GREEN

        log_end(0)
      rescue => e
        log_end(-1, e.message)
        say "Error occurred, aborting", Thor::Shell::Color::RED
        if container
          container.stop()
        end
      rescue SignalException
        log_End(-1)
        if container
          container.stop()
        end
        say "\nAborting"
        exit(1)
      end

    end

    desc 'commit_notebook', 'commit notebook changes to create a new notebook image', :hide => true

    def commit_image
      verify_logged_in(true)
      log_start(__method__, args, options)

      begin
        image = is_project_with_docker(Dir.pwd)
        if image and image.is_docker
          container = image.get_container
          if !container

            say "Couldn't create container with image #{image.image_name}:#{image.image_tag}", Thor::Shell::Color::RED
            exit(1)
          end
        else
          say "Project is not configured with any image", Thor::Shell::Color::RED
          exit(1)

        end
        project_home = get_project_home
        @project = Project.new(project_home)
        last_local_commit = @project.last_local_commit
        say "Commiting container into image", Thor::Shell::Color::BLUE
        new_image_name = "#{@project.slug}#{last_local_commit}:latest"
        image.update_image(new_image_name, container)
        new_image = container.commit('repo' => "#{@project.slug}#{last_local_commit}", 'tag' => "lastest")
        checks = Helpers.checkmark()
        say "#{checks} Done, image was updated", Thor::Shell::Color::GREEN
        log_end(0)
        return new_image.id
      rescue => e
        log_end(-1, e.message)
        say "\nError occurred, aborting"
        exit(1)
      rescue SignalException
        log_end(-1)
        say "\nAborting"
        exit(1)
      end
    end

    desc 'sync_image', 'sync current container into image, and push it to cnvrg repository', :hide => true
    method_option :is_public, :type => :boolean, :aliases => ["-p", "--p"], :default => false, :desc => "is public"
    method_option :is_base, :type => :boolean, :aliases => ["-b", "--b"], :default => false, :desc => "is base for others images"
    method_option :message, :type => :string, :aliases => ["-m", "--m"], :default => "", :desc => "commit message for this image"

    def sync_image(docker = false)
      verify_logged_in(true)
      log_start(__method__, args, options)
      is_public = options["is_public"] || false
      is_base = options["is_base"] || false
      message = options["message"] || ""
      image_id = commit_image

      if docker
        message = "before running experiment"
        image = is_project_with_docker(Dir.pwd)
        if image and image.is_docker
          container = image.get_container
          if !container

            upload_image(image_id, is_public, is_base, message)
          else
            command = ["/bin/bash", "-lc", "cnvrg upload_image #{image_id} #{is_public} #{is_base} #{message}"]
            puts "Running in contianer"
            container.exec(command, detach: false)
          end
        end

      else
        upload_image(image_id, is_public, is_base, message)
      end

    end

    desc 'push', 'push image to cnvrg repository', :hide=> true

    def push(*name)
      verify_logged_in(true)
      log_start(__method__, args, options)
      working_dir = is_cnvrg_dir()
      if !name.empty? and name == "cnvrg"
        log_message("can't create image with the name cnvrg", Thor::Shell::Color::RED)
        exit(1)
      end
      begin
        image = is_project_with_docker(working_dir)
        if !image or !image.is_docker
          log_message("Couldn't find image related to project", Thor::Shell::Color::RED)
          exit(0)
        end
        if !name.nil? and !name.empty?
          if name.include? " "
            name.gsub!(" ", "_")
          end
        end
        stored_commands = File.open(working_dir + "/.cnvrg/custom_image.txt").read.chop.gsub("\n", ",")
        if stored_commands.nil? or stored_commands.empty?
          log_message("Nothing to push", Thor::Shell::Color::BLUE)
          exit(0)
        end

        log_message("Pushing new image", Thor::Shell::Color::BLUE)
        if image.create_custom_image(name, working_dir, stored_commands)

          log_message("Image was updated successfully", Thor::Shell::Color::GREEN)
        end
      rescue => e
        log_message("error occurred, aborting", Thor::Shell::Color::RED)
        log_error(e)

      end
    end




    desc '', '', :hide => true

    def upload_log()
      log_path = '/home/ds/app/uwsgi.log'
      loglines = File.new(log_path).readlines
      logs = loglines.select {|x| x.start_with? "cnvrg_app:"}.collect {|x| x.strip}

    end

    desc 'Collect and send job utilization', '', :hide => true
    method_option :docker_id, :type => :string, :aliases => ["--docker_id"], :desc => "docker id to watch"
    method_option :is_on_gpu, :type => :boolean, :aliases => ["--is_on_gpu"], :desc => "is on gpu", :default => true
    def get_utilization()
      @exp = Experiment.new(ENV['CNVRG_OWNER'], ENV['CNVRG_PROJECT'], job_id: ENV['CNVRG_JOB_ID'])
      docker_id = options["docker_id"]
      while true do
        sleep 30
        begin
          stats = usage_metrics_in_docker(docker_id)
          if options["is_on_gpu"]
            gu = gpu_util(take_from_docker: true, docker_id: docker_id)
            stats['gpu_util'] = gu[0]
            stats['gpu'] = gu[1]
          end
          stats['docker_id'] = docker_id
          @exp.send_machine_stats [stats] unless stats.empty?
        rescue => e
          log_error(e)
          log_message("Failed to upload ongoing stats, continuing with experiment", Thor::Shell::Color::YELLOW)
        end
      end
    end

    desc 'Collect and send job utilization', '', :hide => true
    method_option :prometheus_url, :type => :string, :aliases => ["--prometheus_url"], :desc => "prometheus url to collect metrics from"
    method_option :node_name, :type => :string, :aliases => ["--node_name"], :desc => "machie activity node name"
    method_option :machine, :type => :boolean, :aliases => ["--machine"], :desc => "get machine_query or cluster_query"
    method_option :gpu, :type => :boolean, :aliases => ["--gpu"], :desc => "collect gpu metrics", :default => false
    method_option :gaudi, :type => :boolean, :aliases => ["--gaudi"], :desc => "collect gaudi metrics", :default => false
    method_option :wait, :type => :numeric, :aliases => ["--wait"], :desc => "to to wait between querying", :default => 30
    method_option :prom_user, :type => :string, :aliases => ["--prom_user"], :desc => "prometheus username", :default => nil
    method_option :prom_password, :type => :string, :aliases => ["--prom_password"], :desc => "prometheus password", :default => nil
    method_option :name, :type => :string, :aliases => ["--name"], :desc => "pod name - used for master-workers jobs", :default => nil

    def collect_metrics
      @exp = Experiment.new(ENV['CNVRG_OWNER'], ENV['CNVRG_PROJECT'], job_id: ENV['CNVRG_JOB_ID'])
      prometheus_url = options[:prometheus_url].ends_with?("/") ? options[:prometheus_url] : "#{options[:prometheus_url]}/"
      prom_user = options[:prom_user]
      prom_password = options[:prom_password]
      name = options[:name]

      translate_result = Cnvrg::API_V2.request(
        "#{ENV['CNVRG_OWNER']}/resources/translate_metrics",
        'GET',
        { gpu: options[:gpu], gaudi: options[:gaudi] }
      )

      is_machine = options[:machine]
      while true do
        begin
          stats = {}
          translate_result.each do |query_name, metric|
            if is_machine
              metric_query = metric['machine_query'].presence || metric['query']
              query_content = metric_query.gsub('#JOB_SLUG#', ENV['CNVRG_JOB_ID']).gsub('#NODE_NAME#', options[:node_name])
            else
              metric_query = metric['cluster_query'].presence || metric['query']
              pod_name = `hostname`.strip
              query_content = metric_query.gsub('#JOB_SLUG#', pod_name).gsub('#NODE_NAME#', options[:node_name])
            end
            if metric_query.blank? || query_content.blank?
              next
            end
            uri = URI("#{prometheus_url}api/v1/query?query=#{query_content}")
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = uri.scheme == "https"
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            req = Net::HTTP::Get.new uri.request_uri
            if prom_user.present?
              req.basic_auth(Base64.decode64(prom_user), Base64.decode64(prom_password))
            end
            resp = http.request(req)
            begin
              result = JSON.parse(resp.body)
            rescue JSON::ParserError => e
              log_error(e)
              next
            end
            data_result = result&.dig('data', 'result')
            next unless data_result

            if data_result.size > 1
              stats[query_name] = {} unless query_name.include? 'block'
              data_result.each_with_index do |res, i|
                timestamp, value = res["value"]
                uuid = res["metric"]["UUID"].presence || i
                uuid = res["metric"]["device"] if query_name == "gaudi"
                stat_value = value.present? ? ("%.2f" % value) : 0 # converting 34.685929244444445 to 34.69
                stat_value = stat_value.to_i == stat_value.to_f ? stat_value.to_i : stat_value.to_f # converting 34.00 to 34
                if query_name.include? 'block'
                  uuid = res["metric"]["interface"].presence || i
                  uuid = "#{name}-#{uuid}" if name.present?
                  stats['block_io'] = {} if stats['block_io'].blank?
                  io_type = query_name.split('_')[1]
                  stats['block_io'][io_type] = {} if stats['block_io'][io_type].blank?
                  stats['block_io'][io_type].merge!({ uuid => stat_value })
                else
                  stats[query_name][uuid] = stat_value
                end
              end
            else
              begin
                timestamp, value = data_result&.first&.dig('value')
                stat_value = value.present? ? ("%.2f" % value) : 0 # converting 34.685929244444445 to 34.69
              rescue => e
                Cnvrg::Logger.log_info("Failed converting string into float with error: #{e.message}")
                Cnvrg::Logger.log_error(e)
                stat_value = 0
              end
              stat_value = stat_value.to_i == stat_value.to_f ? stat_value.to_i : stat_value.to_f # converting 34.00 to 34
              if query_name.include? 'block'
                stats['block_io'] = {} if stats['block_io'].blank?
                io_type = query_name.split('_')[1]
                if name.present?
                  stats['block_io'][io_type] = {} if stats['block_io'][io_type].blank?
                  stats['block_io'][io_type].merge!({ name => stat_value })
                else
                  stats['block_io'].merge!({ io_type => stat_value })
                end
              else
                stats[query_name] = name.present? ? { name => stat_value } : stat_value
              end
            end
          end
          @exp.send_machine_stats [stats] unless stats.empty?
        rescue => e
          log_error(e)
          log_message("Failed to upload ongoing stats, continuing with experiment", Thor::Shell::Color::YELLOW)
        end
        sleep options[:wait]
      end
    end

    desc '', '', :hide => true

    def upload_cnvrg_image(image_path, image_name, secret)
      begin
        verify_logged_in(false)

        @files = Cnvrg::Files.new("", "")
        say "Uploading cnvrg  image file", Thor::Shell::Color::BLUE

        res = @files.upload_cnvrg_image(image_path, image_name, secret)
        if res
          say "Successfully uploaded cnvrg image file", Thor::Shell::Color::GREEN

        else
          say "Couldn't upload cnvrg image file", Thor::Shell::Color::RED
        end
      rescue => e
        puts e
        puts e.backtrace
      end


    end

    desc 'file_exists', '', :hide => true
    def file_exists(file)
      exit(0) if File.exists? file
      exit(1)
    end


    desc '', '', :hide => true

    def download_built_image(image_name, image_slug)
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        owner = Cnvrg::CLI.get_owner()
        path = File.expand_path('~') + "/.cnvrg/tmp/#{image_name}.tar.gz"
        @files = Cnvrg::Files.new(owner, "")

        log_message("Downloading image file", Thor::Shell::Color::BLUE)
        begin
          if @files.download_image(path, image_slug, owner)
            gzipRes = system("gunzip -f #{path}")
            if !gzipRes

              log_message("Couldn't create tar file from image", Thor::Shell::Color::RED)
              exit(1)
            else
              path = path.gsub(".gz", "")
              return path
            end

          else
            log_message("Couldn't download image #{image_name}", Thor::Shell::Color::RED)
            return false
          end
        rescue Interrupt
          say "The user has exited to process, aborting", Thor::Shell::Color::BLUE
          exit(1)
        end
      rescue SignalException
        say "\nAborting"
        exit(1)
      end
    end

    desc '', '', :hide => true

    # def download_image(image_name, image_slug)
    #   begin
    #     verify_logged_in(false)
    #     log_start(__method__, args, options)
    #     owner = Cnvrg::CLI.get_owner()
    #     path = File.expand_path('~') + "/.cnvrg/tmp/#{image_name}.zip"
    #     @files = Cnvrg::Files.new(owner, "")
    #
    #     say "Downloading image file", Thor::Shell::Color::BLUE
    #     begin
    #       if @files.download_image(path, image_slug, owner)
    #
    #         dir_path = File.expand_path('~') + "/.cnvrg/tmp/#{image_name}"
    #         FileUtils.rm_rf([dir_path])
    #
    #
    #
    #
    # ::File.open(path) do |zip_file|
    #           zip_file.each do |entry|
    #
    #             f_path = File.join(dir_path, entry.name)
    #             FileUtils.mkdir_p(File.dirname(f_path))
    #             zip_file.extract(entry, f_path)
    #           end
    #         end
    #
    #         return dir_path
    #
    #       else
    #         say "Couldn't download image #{image_name}", Thor::Shell::Color::RED
    #         log_end(1, "can't download image")
    #         return false
    #       end
    #     rescue Interrupt
    #       log_end(-1)
    #       say "The user has exited to process, aborting", Thor::Shell::Color::BLUE
    #       exit(1)
    #     end
    #   rescue SignalException
    #     log_end(-1)
    #     say "\nAborting"
    #     exit(1)
    #   ensure
    #     if !path.nil?
    #       FileUtils.rm(path)
    #     end
    #   end
    # end

    desc '', '', :hide => true

    def download_cnvrg_image(image_name, secret)
      verify_logged_in(false)

      begin
        @files = Cnvrg::Files.new("", "")

        say "Downloading image file", Thor::Shell::Color::BLUE
        begin
          if @files.download_cnvrg_image(image_name, secret)

            say "Successfully downloaded image #{image_name}", Thor::Shell::Color::GREEN

          else
            say "Couldn't download image #{image_name}", Thor::Shell::Color::RED
            return false
          end
        rescue Interrupt
          say "The user has exited to process, aborting", Thor::Shell::Color::BLUE
          exit(1)
        end
      rescue SignalException
        say "\nAborting"
        exit(1)
      end
    end

    desc 'list_images', 'lists all custom images you can pull', :hide => true

    def list_images
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        owner = Cnvrg::CLI.get_owner()
        res = Cnvrg::API.request("users/#{owner}/images/list", 'GET')
        if Cnvrg::CLI.is_response_success(res)
          printf "%-20s %-20s  %-30s %-20s %-20s\n", "name", "project", "created by", "is_public", "last updated"
          res["result"]["images"].each do |u|
            time = Time.parse(u["created_at"])
            update_at = get_local_time(time)
            created_by = u["created_by"]

            printf "%-20s %-20s  %-30s %-20s %-20s\n", u["name"], u["project"], created_by, u["is_public"], update_at
          end
        end
        return res["result"]["images"]
      rescue SignalException
        say "\nAborting"
        exit(1)
      end


    end

    desc 'list_machines', 'Lists all machines belong to your organization', :hide => true
    def list_machines
      begin
        verify_logged_in(false)
        log_start(__method__, args, options)
        owner = Cnvrg::CLI.get_owner()
        res = Cnvrg::API.request("users/#{owner}/machines/list", 'GET')
        if Cnvrg::CLI.is_response_success(res)
          printf "%-20s %-20s %-20s\n", "name", "created by", "last_used"
          res["result"]["machines"].each do |u|
            time = Time.parse(u["last_used"])
            update_at = get_local_time(time)
            printf "%-20s %-20s %-20s\n", u["name"], u["created_by"], update_at
          end
        end
        return res["result"]["images"]
      rescue SignalException
        say "\nAborting"
        exit(1)
      end


    end


    desc 'compare-experiments', 'compare experiments using tensorboard', :hide => true
    method_option :slugs, :type => :string, :aliases => ["-ids"], :desc => "List of experiments slugs to compare"
    method_option :namespace, :type => :string, :aliases => ["-n"], :desc => "experiments pods namespace", :default => "cnvrg"
    method_option :project_slug, :type => :string, :aliases => ["-s"], :desc => "project slug"
    method_option :project_owner, :type => :string, :aliases => ["-o"], :desc => "project slug"
    method_option :frequency, :type => :numeric, :aliases => ["-f"], :desc => "poll frequency"
    method_option :fetch_slugs, :type => :boolean, :default => false, :desc => "Fetch experiments slugs to compare"

    def compare_experiments
      verify_logged_in(true)
      log_start(__method__, args, options)
      exps_map = {}
      copied_commits = []

      if options[:slugs].blank? and options[:fetch_slugs].blank?
        log_message("No experiments slugs given", Thor::Shell::Color::RED)
        return false
      end
      if options[:slugs].present?
        slugs = options[:slugs].split(",")
      end

      frequency = options[:frequency] || 5
      namespace = options[:namespace]
      project_dir = is_cnvrg_dir(Dir.pwd)
      @project = Project.new(project_home=project_dir, slug: options[:project_slug], owner: options[:project_owner])
      fetch_slugs = options[:fetch_slugs]
      webapp_slug = ENV["CNVRG_JOB_ID"]
      if fetch_slugs and webapp_slug.present?
        slugs = @project.fetch_webapp_slugs(webapp_slug)
      end
      if slugs.blank?
        log_message("No experiments slugs given", Thor::Shell::Color::RED)
        return false
      end

      log_message("compare is running")
      while true
        log_message("Comparing the following experiment slugs: #{slugs}")
        slugs.each do |exp_slug|
          begin
            if exps_map[exp_slug].blank?
              exp = @project.get_experiment(exp_slug)["experiment"]
            else
              exp = exps_map[exp_slug]
              log_message("Experiment '#{exp["title"]}' end commit already cloned, skipping it", Thor::Shell::Color::BLUE)
              next
            end
            exp_name = exp["title"]
            if exp["end_commit"].present? and exp["status"] != "Ongoing"
              log_message("Experiment '#{exp_name}' has ended, getting files from its end commit", Thor::Shell::Color::BLUE)
              num_of_new_files = Cnvrg::Helpers.get_experiment_events_log_from_server(exp, @project)
              exps_map[exp_slug] = exp
            else
              log_message("Experiment '#{exp_name}' is running, getting files from its last successful commit", Thor::Shell::Color::BLUE)
              num_of_new_files = Cnvrg::Helpers.get_experiment_events_log_from_server(exp, @project, commit: exp["last_successful_commit"]["sha1"])
              copied_commits << exp["last_successful_commit"]["sha1"]
            end

            log_message("New .tfevent files downloaded", Thor::Shell::Color::BLUE) if num_of_new_files > 0
          rescue => e
            Cnvrg::Logger.log_error(e)
          end
        end
        sleep frequency
        if fetch_slugs
          slugs = @project.fetch_webapp_slugs(webapp_slug, slugs: slugs)
        end
      end
    end

    desc 'experiments', 'List project experiments', :hide => true
    method_option :id, :type => :string, :aliases => ["--id"], :desc => "Get info for specific experiments", :default => ""
    method_option :tag, :type => :string, :aliases => ["-t"], :desc => "Get info for specific experiment tag", :default => ""

    def experiments
      verify_logged_in(true)
      log_start(__method__, args, options)

      project_dir = is_cnvrg_dir(Dir.pwd)
      @project = Project.new(project_dir)
      unless options['id'].to_s.size > 5
        result = @project.get_experiments()
        list = result["result"]["experiments"]
        if list and list.size > 1
          print_table(list)
        else
          say "No experiments"
        end
      else
        result = @project.get_experiment(options['id'])
        result = result.to_h['experiment']
        if result
          if options["tag"].to_s.size == 0
            list = []
            list << result.keys
            list << result.values
            print_table(list)
          else
            if result.keys.include? options["tag"]
              say result[options["tag"]]
            else
              say "No such tag"
            end
          end
        else
          say "No such experiment"
        end


      end

    end

    desc 'get_machine', 'create new aws machine', :hide => true

    def get_machine()
      begin
        verify_logged_in(true)
        log_start(__method__, args, options)
        owner = Cnvrg::CLI.get_owner()
        working_dir = is_cnvrg_dir
        @image = Images.new(working_dir)
        if @image.nil? or !@image.is_docker
          say "Couldn't find image related to this project", Thor::Shell::Color::RED
          exit(0)
        end
        res = Cnvrg::API.request("users/#{owner}/machines/list", 'GET')
        if Cnvrg::CLI.is_response_success(res)
          if res["result"]["machines"].empty?
            create = yes? "No machines available, create new machine?", Thor::Shell::Color::YELLOW
            if create
              instance_type = machine_options(res["result"]["aws_options"])
            else
              exit(0)
            end
          end
          printf "%-20s %-20s %-20s\n", "name", "created by", "last_used", "instance_type"
          res["result"]["machines"].each do |u|
            time = Time.parse(u["last_used"])
            update_at = get_local_time(time)
            printf "%-20s %-20s %-20s\n", u["name"], u["created_by"], update_at, u["instance type"]
          end
        end

      rescue SignalException
        log_end(-1)
        say "\nAborting"
        exit(1)
      end
    end


    desc 'check_pod_restart', 'Check pod restart', :hide => true
    def check_pod_restart
      Cnvrg::CLI.new.log_start(__method__, args, options)
      @project = Project.new(owner: ENV['CNVRG_OWNER'], slug: ENV['CNVRG_PROJECT'])
      @project.check_job_pod_restart
    rescue => e
      Cnvrg::Logger.log_error(e)
      [false, false]
    end

    no_tasks do
      def get_instance_type(instances)
        machines = instances.map {|x| x}.select {|y| y[1]}
        if machines.size == 1
          instance_type = machines[0][0]
        elsif machines.size > 1

          values = instances.map {|x| x[0]}
          machines_str = "#{machines.map {|x| " " + x[0]}.flatten.join(" or")}"

          instance_type = ask ("You can't choose more than 1 machine,either:#{machines_str}")
          instance_type = values.select {|x| x.eql? instance_type}
          if instance_type.empty?
            instance_type = nil
          else
            instance_type = instance_type[0]
          end
        else
          instance_type = nil
        end
        return instance_type
      end

      def get_image(dir)
        project_dir = is_cnvrg_dir(dir)
        if !project_dir
          return false
        else
          project_config = YAML.load_file(project_dir + "/.cnvrg/config.yml")
          if project_config.to_h[:docker]
            project_config.to_h[:image_base]
          else
            false
          end
        end

      end

      def set_owner(owner, username, url=nil)
        home_dir = File.expand_path('~')
        begin
          if !File.directory? home_dir + "/.cnvrg"
            FileUtils.mkdir_p([home_dir + "/.cnvrg", home_dir + "/.cnvrg/tmp"])
          end
          if !File.exist?(home_dir + "/.cnvrg/config.yml")
            FileUtils.touch [home_dir + "/.cnvrg/config.yml"]
          end
          config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
          if config.blank?
            config = {api: "https://app.cnvrg.io/api" }

          end

          if url.blank?
             url = config[:api]
          end
          compression_path = "#{home_dir}/.cnvrg/tmp"
          if config and !config.nil? and !config.empty? and !config.to_h[:compression_path].nil?
            compression_path = config.to_h[:compression_path]
          end
          verify_ssl = false

          if config and !config.nil? and !config.empty? and !config.to_h[:verify_ssl].nil?
            verify_ssl = config.to_h[:verify_ssl]
          end
          config = {owner: owner, username: username, version_last_check: get_start_day(), api: url, compression_path: compression_path, verify_ssl:verify_ssl}

          File.open(home_dir + "/.cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
          return true
        rescue
          return false
        end

      end

      def get_start_day
        time = Time.now
        return Time.new(time.year, time.month, time.day)
      end

      def calc_output_time(upload_output)
        if upload_output.nil? or upload_output.empty?
          return 0
        end
        time = upload_output.split(/(\d+)/).reject(&:empty?).map {|x| x.strip}
        if time.size != 2
          upload_output = ask("upload_output should be {number}{s/m/h/d} i.e. 5m (5 minutes), 1h (1 hour)\nre-enter value for upload_output")
          return calc_output_time(upload_output)
        end
        if time[0] == "0"
          return -1
        end
        case time[1].downcase
          when "s"
            return time[0].to_f
          when "m"
            return time[0].to_f * 60
          when "h"
            return time[0].to_f * 3600
          when "d"
            return time[0].to_f * 24 * 3600
          else
            upload_output = ask("upload_output should be {number}{s/m/h/d} i.e. 5m (5 minutes), 1h (1 hour)\n re-enter value for upload_output")
            calc_output_time(upload_output)
        end

      end

      def calc_output_log_time(log_count)
        return 10
      end

      def log_start(command, args = "", options = {})
        begin
          $LOG.info ruby_version: RUBY_VERSION, os: Cnvrg::Helpers.os(), cli_version: Cnvrg::VERSION
          $LOG.info command: command, args: args, options: options
        rescue
        end
      end

      def self.log_message(message, type = Thor::Shell::Color::BLUE)
        if $LOG.blank?
          ### handle case when $LOG is not initialized
          CLI.new.log_handler
        end
        case type
        when Thor::Shell::Color::BLUE, 'blue', 'progress'
          color = Thor::Shell::Color::BLUE
          $LOG.info message: message, type: "info"
        when Thor::Shell::Color::RED, 'red', 'error'
          color = Thor::Shell::Color::RED
          $LOG.error message: message, type: "error"
        when Thor::Shell::Color::YELLOW, 'yellow', 'warning'
          color = Thor::Shell::Color::YELLOW
          $LOG.warn message: message, type: "warning"
        when Thor::Shell::Color::GREEN, 'green', 'info'
          color = Thor::Shell::Color::GREEN
          $LOG.info message: message, type: "success"
        else
          color = nil
          $LOG.info message: message, type: "unknown"
        end
        say "#{color}#{message}#{Thor::Shell::Color::CLEAR}"
      end

      def log_message(message, type=Thor::Shell::Color::GREEN, to_print = true)
        return if not to_print
        CLI.log_message(message, type)
      end

      def log_error(e)
        begin
          Cnvrg::Logger.log_error(e)
        end
      end


      def log_end(exit_status = 0, error = nil)
        begin
          if exit_status != 0
            $LOG.error exit_status: exit_status, error: error
          else
            $LOG.info exit_status: exit_status
          end
        rescue
        end
      end

      def self.is_response_success(response, should_exit = true)

        begin
          if response.nil? or !response
            # if !Cnvrg::Helpers.internet_connection?
            #   say("<%= color('Error:You seems to be offline', RED) %>")
            #   $LOG.error message: "offline connection", type: "error"
            #
            # end
            if should_exit
              exit(1)
            else
              return false
            end
          elsif response["status"] != 200
            error = response['message'] || "Unknown error"
            # Cnvrg::CLI.log_end(1, error)
            if response["status"] == 500
              log_message('Server Error', Thor::Shell::Color::RED)
            else
              $LOG.error message: error, type: "error"
              log_message(error, Thor::Shell::Color::RED)
            end

            if should_exit
              exit(1)
            else
              return false
            end
          end
          return true
          rescue => e
            puts e.message
            puts e.backtrace
          rescue SignalException
            log_message "Aborting", Thor::Shell::Color::RED
          end

        end


      def self.get_owner
        home_dir = File.expand_path('~')

        config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
        owner = config.to_h[:owner]
        if owner.empty?
          invoke :set_default_owner, [], []
          return get_owner()
        else
          return owner
        end
      end

      def get_base_url
        home_dir = File.expand_path('~')

        config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
        api = config.to_h[:api]
        return api.gsub!("/api", "")
      end

      def get_compression_path
        home_dir = File.expand_path('~')

        config = YAML.load_file(home_dir + "/.cnvrg/config.yml")
        compression_path = config.to_h[:compression_path]
        if compression_path.nil?
          compression_path = "#{home_dir}/.cnvrg/tmp/"
        end
        if !compression_path.ends_with? "/"
          compression_path = compression_path + "/"
        end
        return compression_path
      end

      def get_project_home
        return Cnvrg::CLI.get_project_home
      end

      def get_job

      end

      def self.get_project_home
        absolute_path = Dir.pwd
        dirs = absolute_path.split("/")
        if dirs.empty?
          if Dir.exists? "/.cnvrg"
            return absolute_path
          end
        end
        dirs.pop while not Dir.exists?("#{dirs.join("/")}/.cnvrg") and dirs.size != 0

        if dirs.size == 0
          log_message("Couldn't find cnvrg directory. Please start a new project", Thor::Shell::Color::RED)
          puts Thread.current.backtrace
          exit(1)
        end
        return dirs.join("/")
      end

      def should_update_version
        res = Cnvrg::API.request("cli/version", 'GET')
        if Cnvrg::CLI.is_response_success(res, false)
          updated_version = res["result"]["version"]
          if updated_version != Cnvrg::VERSION
            return true
          else
            return false
          end
        else
          return false
        end
      end

      def log_handler
        begin
          date = DateTime.now.strftime("%m_%d_%Y")
          home_dir = File.expand_path('~')

          if !File.directory? home_dir + "/.cnvrg"
            FileUtils.mkdir_p([home_dir + "/.cnvrg", home_dir + "/.cnvrg/tmp"])
          end
          if !File.exist?(home_dir + "/.cnvrg/config.yml")
            FileUtils.touch [home_dir + "/.cnvrg/config.yml"]
          end
          logfile = File.expand_path('~') + "/.cnvrg/log_#{date}.log"
          if !File.exist? logfile
            FileUtils.touch([logfile])
            yesterday = get_start_day - 86399
            date = yesterday.strftime("%m_%d_%Y")

            logfile_old = File.expand_path('~') + "/.cnvrg/log_#{date}.log"
            count = 0
            while not File.exist? logfile_old and count < 60
              yesterday = yesterday - 86399
              date = yesterday.strftime("%m_%d_%Y")
              logfile_old = File.expand_path('~') + "/.cnvrg/log_#{date}.log"
              count += 1
            end
            if File.exist? logfile_old
              #@files = Cnvrg::Files.new(Cnvrg::CLI.get_owner, "")
              #@files.upload_log_file(logfile_old, "log_#{date}.log", yesterday)
              FileUtils.remove logfile_old
            end

          end
          config = LogStashLogger.configure do |config|
            config.customize_event do |event|
              event.remove('@version')
              event.remove('severity')
            end
          end
          $LOG = LogStashLogger.new(type: :file, path: logfile, sync: true, config: config)
          remove_old_log_files()
        rescue
        end
      end

        def verify_logged_in(in_dir=true)
          begin
          log_handler()
          auth = Cnvrg::Auth.new
          unless auth.is_logged_in?
            log_message("You\'re not logged in\nPlease log in via `cnvrg login`", Thor::Shell::Color::RED)

            exit(1)
          end

          # if !Helpers.internet_connection?
          #   wait_offline = agree "Seems like you're offline, wait until your'e back online?", Thor::Shell::Color::YELLOW
          #   if wait_offline
          #     say "Waiting until your'e online..", Thor::Shell::Color::BLUE
          #     while !Cnvrg::Helpers.internet_connection?
          #     end
          #   else
          #     say "you seem to be offline, please check your internet connection", Thor::Shell::Color::RED
          #     exit(0)
          #   end
          # end

        # config = YAML.load_file(File.expand_path('~') + "/.cnvrg/config.yml")
        # version_date = config.to_h[:version_last_check]
        # if version_date.nil?
        #   version_date = get_start_day()
        # end
        #   next_day = get_start_day + 86399
        #   version_date = version_date.to_i
        #   next_day = next_day.to_i
        # if not (version_date..next_day).cover?(Time.now)
        #   if should_update_version()
        #     say "There is a new version, run gem update cnvrg", Thor::Shell::Color::BLUE
        #   end
        # end
        if in_dir
          is_cnvrg = is_cnvrg_dir
          if !is_cnvrg
            say "You're not in a cnvrg project directory", Thor::Shell::Color::RED
            exit(1)
          end

        end
        #verify tmp dirs exist
        home_dir = File.expand_path('~')

          FileUtils.mkdir_p([home_dir+"/.cnvrg", home_dir+"/.cnvrg/tmp", home_dir+"/.cnvrg/tmp_files"])
          rescue SignalException

          end

      end

      def is_cnvrg_dir(dir = Dir.pwd)
        current_dir = dir
        home_dir = File.expand_path('~')
        # if current_dir.eql? home_dir
        #   return false
        # end
        is_cnvrg = Dir.exist? current_dir + "/.cnvrg"
        until is_cnvrg == true
          current_dir = File.expand_path("..", current_dir)
          is_cnvrg = Dir.exist? current_dir + "/.cnvrg"
          if ((File.expand_path("..", current_dir).eql? home_dir) or current_dir.eql? home_dir or current_dir.eql? "/") and !is_cnvrg
            is_cnvrg = false
            break
          end
        end
        if is_cnvrg
          self.update_project_config(current_dir)
          return current_dir
        else
          return false
        end
      end



      def update_project_config(current_dir)
        @project = Cnvrg::Project.new(current_dir)
        #appearently, dataset tries to run this function.
        # this code VV handle this.
        return if @project.slug.blank?
        @project.fetch_project
      end

      def data_dir_include()
        all_dirs = Dir.glob("**/*/", File::FNM_DOTMATCH)
        all_dirs.flatten!
        all_dirs.each do |a|
          if a.include? "/.cnvrg"
            ignore = File.dirname(a)
            return ignore
          end
        end
        return nil

      end

      def verify_software_installed(software)
        begin
          install_url = Cnvrg::CLI::INSTALLATION_URLS[software.to_sym]
          installed = `which #{software}`
          if installed.empty? or installed.nil?
            say "#{software} isn't installed, please install it first: #{install_url}", Thor::Shell::Color::RED
            exit(1)
          end
          installed.strip!
          case software
            when "docker"
              is_running = system("#{installed} images>/dev/null 2>&1")
              if not is_running
                if Helpers.mac?
                  say "docker isn't running. run:\ndocker-machine start default 2>/dev/null & eval `docker-machine env default`", Thor::Shell::Color::BLUE
                  exit(1)
                elsif Helpers.ubuntu?
                  #TODO: change here
                  say "docker isn't running. run:\ndocker-machine start default 2>/dev/null & eval `docker-machine env default`", Thor::Shell::Color::BLUE
                  exit(1)
                end
              end
          end

          return true
        rescue
          exit(1)
        end

      end

      def get_local_time(time_to_update)
        local = Time.now.localtime
        gmt_offset = local.gmt_offset
        new_time = time_to_update +gmt_offset
        return new_time.to_s.gsub("UTC", "")

      end


      def is_project_with_docker(dir)
        project_dir = is_cnvrg_dir(dir)
        if !project_dir
          return false
        else
          project_config = YAML.load_file(project_dir + "/.cnvrg/config.yml")
          if project_config.to_h[:docker]
            image = Images.new(project_dir)
            return image
          else
            false
          end
        end


      end

      def machine_options(aws_options)
        begin
          say "Choose type of machine:", Thor::Shell::Color::BLUE
          printf "%-20s %-20s %-30s\n", "type", "details", "options"
          all_options = []
          aws_options.each do |a|
            all_options << a["options"].flatten
            options = a["options"].join(" ")
            printf "%-20s %-20s %-30s\n", a["type"], a["details"], options
          end
          all_options.flatten!
          instance_type = ask "which type of machine?", Thor::Shell::Color::YELLOW
          count = 0
          while !all_options.include? instance_type and count < 4
            say "Couldn't find #{instance_type}", Thor::Shell::Color::RED
            instance_type = ask "which type of machine?", Thor::Shell::Color::YELLOW
            count += 1
          end
          return instance_type
        rescue
          return false
        rescue SignalException
          say "\nAborting", Thor::Shell::Color::RED
          Exit(0)
        end


      end


      def is_port_taken(ip = Cnvrg::CLI::IP, port = Cnvrg::CLI::PORT, seconds = 1)
        Timeout::timeout(seconds) do
          begin
            TCPSocket.new(ip, port).close
            true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            false
          end
        end
      rescue Timeout::Error
        false
      end

      def image_activity(image)
        res = image.handle_image_activity
        if res == -1
          #image is not known
          say "Images #{image.image_name} is not known", Thor::Shell::Color::YELLOW
          to_sync = yes? "Sync image?", Thor::Shell::Color::YELLOW
          if to_sync
            sync_image()
            res = image.handle_image_activity()
            return res
          else
            return false
          end

        end
        return res

      end

      def get_note_url(working_dir)
        config = YAML.load_file(working_dir + "/.cnvrg/config.yml")
        return config[:notebook_slug]

      end

      def get_schedule_date()

        local = Time.now.localtime
        # gmt_offset = local.gmt_offset
        new_time = (local).to_s
        new_time = new_time[0, new_time.size - 6] #remove timezone
        return new_time

      end



        def format_schedule(schedule)
          if schedule.start_with? 'in'
            time = schedule.split(" ")

            local = Time.now.localtime
            if time[2].downcase().start_with? "min"
              new = local + (time[1].to_i * 60)
            elsif time[2].downcase().start_with? "hours"
              new = local + (time[1].to_i * 3600)
            elsif time[2].downcase().start_with? "days"
              new = local + (time[1].to_i * 3600 * 24)
            else
              log_message("Could not undersatnd when to schedule experiment", Thor::Shell::Color::RED)
              exit(1)
            end
            new_time = new.to_s
            new_time = new_time[0, new_time.size-6] #remove timezone
            schedule = "at #{new_time}"
          end
          schedule
        end
      def update_deleted(deleted)
        final = []
        deleted.each do |d|
          all_subs = d.split("/")
          to_add = true
          value = all_subs[0]
          all_subs.each_with_index do |a, i|
            if final.include? value+"/"
              to_add = false
              break
            end
            value = value + "/" + all_subs[i + 1] if i < all_subs.size - 1
          end
          final << d if to_add

        end


        return final
      end

      def get_cmd_path_in_dir(main_dir, sub_dir)
        first = Pathname.new main_dir
        second = Pathname.new sub_dir
        relative = second.relative_path_from first
        if relative.eql? "."
          return ""
        else
          return relative
        end
      end

      def create_docker_tar(docker_path, tar_path)
        begin

          if File.directory? (docker_path)
            `cd #{docker_path} && tar -czf #{tar_path} . `
          else
            dir_name = File.dirname docker_path
            `cd #{dir_name} &&  tar -czf #{tar_path} #{File.basename(docker_path)}`
          end
        rescue => e
          puts "Exception while compressing docker path: #{e.message}"
        end

        return $?.success?
      end

      def create_tar(path_in, path_out, tar_files, no_compression = false, ignore_files_path)
        #The cd is meant for cases when running cnvrg data uplaod not in the main folder
        begin
          ignore = ""
          if !ignore_files_path.nil?
            ignore = "--exclude-from=#{ignore_files_path}"
          end
          if no_compression
            `cd #{path_in} && tar -cf #{path_out} -T #{tar_files} #{ignore}`
          else
            `cd #{path_in} && tar -czf #{path_out} -T #{tar_files} #{ignore}`
          end
        rescue => e
          puts "Exception while compressing data: #{e.message}"
        end

        return $?.success?
      end

      def extarct_tar(file_path, dir_path)
        `tar -xvf #{file_path} -C #{dir_path} > /dev/null 2>&1`
        return $?.success?
      end

      def cpu_usage
        if !Helpers.ubuntu?
          return 0.0
        end
        cpu_usage = 0.0
        begin
          cpu = `top b -n 2 -d 2 |grep %Cpu |tail -1 |awk '{print $2+$3}'`
          if !cpu.nil?
            cpu_usage = cpu.to_f
          end
        rescue
          cpu_usage = 0.0
        end

        return cpu_usage
      end

      def memory_usage
        if !Helpers.ubuntu?
          return 0.0
        end
        prec = 0.0
        used = `free -mt |grep Mem: |awk '{print $3}'`
        begin
          total = `free -mt |grep Mem: |awk '{print $2}'`

          used_f = used.to_f if !used.nil?
          total_f = total.to_f if !total.nil?
          prec = (used_f / total_f) * 100
          prec = prec.round(2)
        rescue
          prec = 0.0
        end
        return prec


      end

      def gpu_util(take_from_docker: false, docker_id: nil)
        if !Helpers.ubuntu?
          return 0.0
        end
        stats = [[],[]]
        begin
          if take_from_docker
            gpu_stats = `docker exec -it #{docker_id} sh -c 'nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv'`
          else
            gpu_stats = `nvidia-smi --query-gpu=utilization.gpu,utilization.memory --format=csv`
          end

          if !gpu_stats.nil?
            gpu_stats = gpu_stats.split("\n")[1..-1]
            stats = [[],[]]
            gpu_stats.each do |stat|
              gpu = stat.strip.gsub!("%", "").split(",")
              stats[0] << gpu[0].to_f
              stats[1] << gpu[1].to_f
            end
            return stats
          end

        rescue
          return stats
        end


      end

      def usage_metrics_in_docker(docker_id)
        res = {cpu: 0.0, memory: 0.0, block_io: {input: 0, output: 0.0}}
        begin
          if docker_id.nil?
            docker_id = `cat /etc/hostname`
          end
          stats = `sudo docker stats #{docker_id} --no-stream --format "{{.CPUPerc}},{{.MemPerc}},{{.BlockIO}}"`
          if !stats.nil?
            conv = stats.split(",")
            cpu = conv[0].gsub!("%", "").to_f
            res[:cpu] = cpu
            memory = conv[1].gsub!("%", "").to_f
            res[:memory] = memory
            block_io = parse_io conv[2]
            res = {cpu: cpu, memory: memory, block_io: block_io}
            return res
          end
        rescue
          return res
        end
      end



      def parse_io(block_io_str)
        block_io = block_io_str.gsub(" ", "").split('/')
        input = block_io[0]
        output = block_io[1]
        r = Regexp.new('(\d+(\.\d+)?)([A-Za-z]+)')
        input_match = r.match(input)
        input = input_match[1].to_f * size_to_bytes(input_match[3])
        output_match = r.match(output)
        output = output_match[1].to_f * size_to_bytes(output_match[3])
        {input: input, output: output}
      end


      def size_to_bytes size
        case size.try(:downcase)
        when 'b'
          1
        when 'kb'
          2**10
        when 'mb'
          2**20
        when 'gb'
          2**30
        else
          1
        end
      end

      def exec_local(cmd , print_log, start_commit, real, start_time)
        log = []
        PTY.spawn(@exp.as_env, cmd) do |stdout, stdin, pid, stderr|
          begin
            stdout.each do |line|
              cur_time = Time.now
              real_time = Time.now - real
              cur_log = {time: cur_time,
                         message: line,
                         type: "stdout",
                         real: real_time
              }
              if print_log
                puts({log: line, timestamp: Time.now, exp_logs: true}.to_json)
              end
              log << cur_log
              if log.size >= 10
                @exp.upload_temp_log(log) unless log.empty?
                log = []
              elsif (start_time + 15.seconds) <= Time.now
                @exp.upload_temp_log(log) unless log.empty?
                log = []
                start_time = Time.now
              end
            end
            if stderr
              stderr.each do |err|
                log << {time: Time.now, message: err, type: "stderr"}
              end
            end
          rescue Errno::EIO => e
            log_error(e)
            if !log.empty?
              temp_log = log
              @exp.upload_temp_log(temp_log) unless temp_log.empty?
              log -= temp_log
            end
          rescue Errno::ENOENT => e
            exp_success = false
            log_message("command \"#{cmd}\" couldn't be executed, verify command is valid", Thor::Shell::Color::RED)
            log_error(e)
          rescue => e
            res = @exp.end(log, 1, start_commit, 0, 0)
            log_message("Error occurred,aborting", Thor::Shell::Color::RED)
            log_error(e)
            exit(0)
          end
          ::Process.wait pid
        end
      end


      def fetch_experiment_info(res, project, end_pos)

        result =
          Cnvrg::API_V2
            .request("#{project.owner}/projects/#{project.slug}/experiments/#{res["result"]["exp_url"]}/info",
          'GET',
          { exit_status: true, grid: res["result"]["grid"], pos: end_pos }
        )

        if result.key?("exit_status")
          return result
        end

        return result["data"]["attributes"]["info"]

      end

    end
  end

end


