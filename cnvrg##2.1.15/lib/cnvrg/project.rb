require 'fileutils'
require 'pathname'

module Cnvrg
  class Project
    attr_reader :slug, :owner, :title, :local_path, :working_dir, :is_git, :is_branch, :machines

    RemoteURL ||= "https://cnvrg.io"
    IDXParallelThreads ||= Cnvrg::Helpers.parallel_threads

    def initialize(project_home = nil, slug: nil, owner: nil)
      begin
        @local_path = project_home
        @working_dir = project_home
        # read from env and new config file
        config = Cnvrg::Helpers.get_config_v2_project(project_home, owner, slug)
        @title = config[:project_name]
        @slug = config[:project_slug]
        @owner = config[:owner]
        @is_branch = config[:is_branch]
        @is_git = config[:git] || false
        @base_resource = "users/#{@owner}/projects/#{@slug}/"
        @machines = nil
      rescue => e
      end
    end

    def base_resource
      "users/#{@owner}/projects/#{@slug}/"
    end

    def last_local_commit
      YAML.load_file(@local_path + "/.cnvrg/idx.yml")[:commit] rescue nil
    end

    def url
      url = Cnvrg::Helpers.remote_url
      "#{url}/#{self.owner}/projects/#{self.slug}"
    end

    def update_ignore_list(new_ignore)
      if new_ignore.nil? or new_ignore.empty?
        return true
      end
      list = new_ignore.split(",")
      begin
        File.open(self.local_path + "/.cnvrgignore", "a+") do |f|
          f.puts("\n")
          list.each do |i|
            f.puts("#{i}\n")
          end
        end
        return true
      rescue
        return false
      end
    end

    def get_ignore_list
      ignore_list = []
      if !File.exist? self.local_path + "/.cnvrgignore"
        return ignore_list
      end
      File.open(self.local_path + "/.cnvrgignore", "r").each_line do |line|
        line = line.strip
        if line.start_with? "#" or ignore_list.include? line or line.empty?
          next
        end
        if line.end_with? "*"
          list_regex = Dir.glob("**/#{line}", File::FNM_DOTMATCH).flatten
          list_regex.each do |l|
            ignore_list << l
            if File.directory?(l)
              all_sub = Dir.glob("#{line}/**/*", File::FNM_DOTMATCH).flatten

              ignore_list << all_sub.flatten
            end

          end
        elsif line.end_with? "/*"
          line = line.gsub("/*", "")
          regex_list = Dir.glob("**/#{line}/**/*", File::FNM_DOTMATCH).flatten
          ignore_list << regex_list
        elsif line.include? "*"
          regex_list = Dir.glob("**/#{line}").flatten
          ignore_list << regex_list
        elsif line.end_with? "/" or File.directory?(line)
          ignore_list << line
          all_sub = Dir.glob("#{line}/**/*", File::FNM_DOTMATCH).flatten

          ignore_list << all_sub.flatten

        else
          ignore_list << line
        end
      end
      return ignore_list.flatten

    end

    def send_ignore_list()
      begin
        ignore_list = []
        File.open(self.local_path + "/.cnvrgignore", "r").each_line do |line|
          line = line.strip
          if line.start_with? "#" or ignore_list.include? line or line.empty?
            next
          end
          if line.end_with? "/"
            ignore_list << line.gsub("/", "")
            ignore_list << line + "."
          elsif line.include? "*"
            line = line.gsub("*", ".*")
            ignore_list << line
          else
            ignore_list << line
          end
        end
        return ignore_list.flatten
      rescue
        return []
      end

    end

    # Create project

    def self.create(project_name, clean, with_docker = false, bucket: nil)
      if clean
        list_dirs = [project_name, project_name + "/.cnvrg"]
      else

        list_dirs = [project_name,
                     project_name + "/models",
                     project_name + "/notebooks",
                     project_name + "/src",
                     project_name + "/src/visualizations",
                     project_name + "/src/features",
                     project_name + "/.cnvrg"
        ]
      end

      list_files = [
        project_name + "/README.md",
        project_name + "/.cnvrgignore",
        project_name + "/.cnvrg/config.yml"
      ]
      cnvrgreadme = Helpers.readme_content
      cnvrgignore = Helpers.cnvrgignore_content
      cnvrghyper = Helpers.hyper_content

      begin

        owner = Cnvrg::CLI.get_owner()
        response = Cnvrg::API.request("cli/create_project", 'POST', { title: project_name, owner: owner, is_docker: with_docker, bucket: bucket })
        Cnvrg::CLI.is_response_success(response)
        response = JSON.parse response["result"]
        project_slug = response["slug"]

        config = { project_name: project_name,
                   project_slug: project_slug,
                   owner: owner,
                   docker: with_docker }
        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files

        File.open(project_name + "/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
        File.open(project_name + "/.cnvrgignore", "w+") { |f| f.write cnvrgignore }
        File.open(project_name + "/README.md", "w+") { |f| f.write cnvrgreadme }
        File.open(project_name + "/src/hyper.yaml", "w+") { |f| f.write cnvrghyper }

      rescue
        return false
      end
      return true
    end

    def self.link(owner, project_name, docker = false, git = false, bucket: nil)
      ignore_exits = File.exist? ".cnvrgignore"
      list_dirs = [".cnvrg"
      ]
      list_files = [
        ".cnvrg/config.yml"
      ]
      if !ignore_exits
        list_files <<
          ".cnvrgignore"
      end

      cnvrgreadme = Helpers.readme_content
      cnvrgignore = Helpers.cnvrgignore_content
      begin
        response = Cnvrg::API.request("cli/create_project", 'POST', { title: project_name, owner: owner, is_docker: docker, bucket: bucket })
        Cnvrg::CLI.is_response_success(response)
        response = JSON.parse response["result"]
        project_slug = response["slug"]

        config = { project_name: project_name,
                   project_slug: project_slug,
                   owner: owner,
                   git: git }
        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files
        File.open(".cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
        File.open(".cnvrgignore", "w+") { |f| f.write cnvrgignore } unless ignore_exits
        if !File.exist? "README" and !File.exist? "README.md"
          FileUtils.touch ["README.md"]
          File.open("README.md", "w+") { |f| f.write cnvrgreadme }
        end

      rescue => e
        puts e
        return false
      end
      return true
    end

    def self.clone_dir(project_slug, project_owner, project_name, is_git = false)
      list_dirs = [project_name,
                   project_name + "/.cnvrg"
      ]

      list_files = [
        project_name + "/.cnvrg/config.yml",
        project_name + "/.cnvrgignore",
      ]
      begin
        config = { project_name: project_name,
                   project_slug: project_slug,
                   owner: project_owner,
                   git: is_git }
        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files
        cnvrgignore = Helpers.cnvrgignore_content

        File.open(project_name + "/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
        File.open(project_name + "/.cnvrgignore", "w+") { |f| f.write cnvrgignore }

      rescue
        return false
      end
      return true
    end

    def self.verify_cnvrgignore_exist(project_name, remote)
      path = ".cnvrgignore"
      if !File.exist? path
        path = "#{project_name}/.cnvrgignore"
      end
      ignore_exits = File.exist? path
      if !ignore_exits
        begin
          list_files = [
            path
          ]
          FileUtils.touch list_files
          cnvrgignore = Helpers.cnvrgignore_content
          File.open(path, "w+") { |f| f.write cnvrgignore }
        rescue => e
          return false
        end

      end
    end

    def self.clone_dir_remote(project_slug, project_owner, project_name, is_git = false)
      cli = Cnvrg::CLI.new()
      begin
        list_dirs = [
          ".cnvrg"
        ]

        list_files = [
          ".cnvrg/config.yml",

        ]

        config = { project_name: project_name,
                   project_slug: project_slug,
                   owner: project_owner,
                   git: is_git
        }
        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files

        File.open(".cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
        if !File.exist? ".cnvrgignore"
          FileUtils.touch ".cnvrgignore"
          list_files << ".cnvrgignore"
          cnvrgignore = Helpers.cnvrgignore_content
          File.open(".cnvrgignore", "w+") { |f| f.write cnvrgignore }

        end
        true
      rescue => e
        cli.log_message(e.message)
        cli.log_error(e)
        false
      end
    end

    def update_is_new_branch(new_branch)
      config = YAML.load_file(@working_dir + "/.cnvrg/config.yml")
      config[:new_branch] = new_branch
      File.open(@working_dir + "/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
    end

    def get_new_branch
      begin
        config = YAML.load_file(@working_dir + "/.cnvrg/config.yml")
        return config[:new_branch]
      rescue => e
        return false
      end
    end

    def get_config
      YAML.load_file(@working_dir + "/.cnvrg/config.yml") rescue {}
    end

    def get_storage_client
      client_params = nil
      i = 0
      begin
        response = Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/client", 'GET')
        unless Cnvrg::CLI.is_response_success(response, false)
          raise StandardError.new("Can't find project credentials")
        end
        client_params = response['client']
      rescue StandardError
        i += 1
        sleep(5 * i)
        retry if i < 10
        client_params = get_storage_client_fallback
      end
      raise StandardError.new("Can't find project credentials") unless client_params
      Cnvrg::Downloader::Client.factory(client_params)
    end

    def get_storage_client_fallback
      response = Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/download_files", "POST", { files: [], commit: get_latest_commit })
      raise StandardError.new("Can't find project credentials") unless Cnvrg::CLI.is_response_success(response, false)
      files = response['result']
      storage = files['is_s3'] ? 's3' : 'minio'
      files['storage'] = storage
      files
    end

    def get_latest_commit
      resp = clone(0, '')

      resp['result']['commit']
    end

    def set_config(config)
      slug = config[:project_slug] rescue nil
      owner = config[:owner] rescue nil
      name = config[:project_name] rescue nil
      if slug.blank? or owner.blank? or name.blank?
        return
      end
      File.open(@working_dir + "/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
    end

    def remove_new_branch
      config = YAML.load_file(@working_dir + "/.cnvrg/config.yml")
      new_config = config.except(:new_branch)
      File.open(@working_dir + "/.cnvrg/config.yml", "w+") { |f| f.write new_config.to_yaml }
    end

    def generate_git_diff
      git_diff = `git diff --name-only`
      git_diff.split("\n")
    rescue
      []
    end

    def generate_output_dir(output_dir, local: false)
      Cnvrg::Logger.log_info("Generating output dir for #{output_dir}")
      upload_list = []
      list = []
      list = Dir.glob("/cnvrg/#{output_dir}/**/*", File::FNM_DOTMATCH)
      if local
        list += Dir.glob("#{output_dir}/**/*", File::FNM_DOTMATCH)
      end
      list.uniq!
      Parallel.map(list, in_threads: IDXParallelThreads) do |e|
        next if e.end_with? "/."
        if File.directory? e
          upload_list << e + "/"
        else
          upload_list << e
        end
      end
      if Dir.exists? output_dir
        upload_list << output_dir + "/"
      end
      Cnvrg::Logger.log_info("Uploading: #{upload_list.join(", ")}")
      upload_list
    end

    def generate_output_dir_tmp(output_dir)
      upload_list = []
      list = Dir.glob("#{output_dir}/**/*", File::FNM_DOTMATCH)
      Parallel.map(list, in_threads: IDXParallelThreads) do |e|
        next if e.end_with? "/."
        if File.directory? e

          next
        else
          upload_list << e
        end
      end
      # if Dir.exists? output_dir
      #   upload_list << output_dir + "/"
      # end

      return upload_list

    end

    def generate_idx(deploy: false, files: [])
      if File.exists? "#{self.local_path}/.cnvrg/idx.yml"
        old_idx = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml") rescue { :tree => {}, :commit => nil }
      else
        old_idx = { :tree => {}, :commit => nil }
      end

      tree_idx = Hash.new(0)

      ### if file specified, just take them, dont calculate everything from scratch
      list_ignore = self.get_ignore_list()
      if files.blank?
        list = Dir.glob("#{self.local_path}/**/*", File::FNM_DOTMATCH).reject { |x| (x =~ /\/\.{1,2}$/) or (x =~ /^#{self.local_path}\/\.cnvrg\/*/) or (x =~ /^#{self.local_path}\/\.git\/*/) or (x =~ /^#{self.local_path}\/\.cnvrgignore.conflict*/) and not (x =~ /^#{self.local_path}\/\.cnvrgignore/) }
      else
        list = files
      end
      if deploy
        list_ignore += ["main.py", "main.pyc", "__init__.py", "uwsgi.ini"]
        list_ignore.flatten!
      end
      list_ignore_new = list_ignore.map { |x| x.gsub("//", "/") } rescue []
      # list.each do |e|
      Parallel.map(list, in_threads: IDXParallelThreads) do |e|
        label = e.sub(self.local_path + "/", "")

        if list_ignore_new.include? label
          next
        end
        if File.symlink?(e)
          Cnvrg::Logger.log_info("Skipping symlink #{e}")
          next
        end
        if File.directory? e
          dir_name = (label.ends_with? "/") ? label : (label + "/")
          tree_idx[dir_name] = nil
        else
          file_in_idx = old_idx[:tree][label] rescue nil
          last_modified = File.mtime(e).to_f
          if file_in_idx.present? and last_modified == file_in_idx[:last_modified]
            sha1 = file_in_idx[:sha1]
          else
            sha1 = OpenSSL::Digest::SHA1.file(e).hexdigest
          end

          if old_idx.nil? or old_idx.to_h[:tree].nil?
            tree_idx[label] = { sha1: sha1, commit_time: nil, last_modified: last_modified }
          elsif file_in_idx.nil? or file_in_idx[:sha1] != sha1 or file_in_idx[:last_modified].blank? or file_in_idx[:last_modified] != last_modified
            tree_idx[label] = { sha1: sha1, commit_time: nil, last_modified: last_modified }
          else
            tree_idx[label] = old_idx[:tree][label]
          end
        end
      end
      old_idx[:tree] = tree_idx
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') { |f| f.write old_idx.to_yaml }
      return YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
    end

    def get_idx
      unless File.exists? "#{self.local_path}/.cnvrg/idx.yml"
        empty_idx = { :commit => nil, :tree => {} }
        File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') { |f| f.write empty_idx.to_yaml }
        return empty_idx
      end
      YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
    end

    def set_idx(idx)
      FileUtils.mkdir_p("#{self.local_path}/.cnvrg")
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') { |f| f.write idx.to_yaml }
    end

    def clone(remote = 0, commit)
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/clone", 'POST', { project_slug: self.slug, remote: remote, commit: commit })
      return response
    end

    def git_download_commit(commit)
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/git_download_commit", 'POST', { commit_sha1: commit })
      CLI.is_response_success(response, true)
      return response
    end

    def get_job_last_commit(job_type, job_id)
      base_url = "users/#{self.owner}/projects/#{self.slug}/jobs/#{job_type.underscore}/#{job_id}"
      resp = Cnvrg::API.request("#{base_url}/last_commit", "GET")
      commit = resp["commit"]
      return commit
    end

    def compare_idx(new_branch, force: false, deploy: false, in_exp: false, specific_files: [], download: false)
      is_download = download
      if is_download
        local_idx = self.get_idx
      else
        #upload
        local_idx = self.generate_idx(deploy: deploy, files: specific_files)
      end

      commit = local_idx[:commit]
      tree = local_idx[:tree]
      ignore_list = self.send_ignore_list()
      if force or specific_files.present?
        added = []
        if tree.present?
          added += local_idx[:tree].keys
        end
        response = { "result" => { "commit" => nil, "tree" => { "added" => added,
                                                                "updated_on_server" => [],
                                                                "updated_on_local" => [],
                                                                "update_local" => [],
                                                                "deleted" => [],
                                                                "conflicts" => [] } } }
        return response
      end
      #we dont want to send it on download - we only compare between commits sha1 in download.
      if is_download
        #the new server doesnt need the tree, but the old probably needs :X
        local_idx[:tree] = {} if Cnvrg::Helpers.server_version > 0
      end

      response = Cnvrg::API.request(@base_resource + "status", 'POST', { idx: local_idx, new_branch: new_branch,
                                                                         current_commit: commit, ignore: ignore_list, force: force, in_exp: in_exp, download: download })

      CLI.is_response_success(response, true)
      if is_download
        if Cnvrg::Helpers.server_version > 0
          #trying to optimize the download using resolver
          resolve = response['result']['tree']['resolver'] || tree #tree of file -> sha1 from current commit to check conflicts
          destination_files = response['result']['tree']['destination'] || {} #tree of file -> sha1 from last commit to check files that already downloaded
        else
          resolve = tree
          destination_files = {}
        end
        @files = self.get_files
        local_tree = @files.calculate_sha1(resolve.keys)
        changed_files = resolve.keys.select { |file| local_tree[file] != resolve[file] }

        # means that the user changed the file locally
        response['result']['tree']['update_local'] = changed_files

        # means that we already downloaded this file and we dont need it anymore
        downloaded_files = destination_files.keys.select { |file| local_tree[file] == destination_files[file] }
        response['result']['tree']['added'] -= downloaded_files
        response['result']['tree']['updated_on_server'] -= downloaded_files
      end
      Cnvrg::Logger.log_json(response, msg: "Comparing IDX response(tree)")
      return response
    end

    def get_files
      Cnvrg::Files.new(self.owner, self.slug, project_home: @local_path)
    end

    def jump_idx(destination: self.last_local_commit)
      local_idx = self.generate_idx
      ignore_list = self.send_ignore_list
      current_commit = local_idx[:commit]
      tree = local_idx[:tree]
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/jump_to",
                                    'POST',
                                    { tree: tree, ignore: ignore_list,
                                      dest_commit: destination, current_commit: current_commit })
      CLI.is_response_success(response, false)
      response
    end

    def set_on_branch(is_latest)
      config = YAML.load_file(@working_dir + "/.cnvrg/config.yml")
      @is_branch = !is_latest
      config[:is_branch] = @is_branch

      File.open(@working_dir + "/.cnvrg/config.yml", 'w') { |f| f.write config.to_yaml }

    end

    def compare_commit(commit)
      if commit.nil? or commit.empty?
        commit = last_local_commit
      end
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/commit/compare", 'POST', { current_commit: commit })
      CLI.is_response_success(response, false)
      update_is_new_branch(response["result"]["new_branch"])
      return response["result"]["new_branch"]
    end

    def update_idx_with_files_commits!(files, commit_time)

      idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      files.each do |path|
        idx_hash[:tree].to_h[path].to_h[:commit_time] = commit_time
      end
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') { |f| f.write idx_hash.to_yaml }

      return true
    end

    def deploy(file_to_run, function, input_params, commit_to_run, instance_type, image_slug, scheduling_query, local_timestamp, workers, file_input, title)
      response = Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/deploy", 'POST', { file_to_run: file_to_run, function: function,
                                                                                          image_slug: image_slug, input_params: input_params,
                                                                                          commit_sha1: commit_to_run,
                                                                                          instance_type: instance_type,
                                                                                          scheduling_query: scheduling_query,
                                                                                          local_timestamp: local_timestamp,
                                                                                          workers: workers, file_input: file_input,
                                                                                          title: title })
      return response
    end

    def list_commits
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/commits/list", 'GET')
      CLI.is_response_success(response)
      return response
    end

    def get_experiments
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/experiments/list", 'GET')
      CLI.is_response_success(response)
      return response
    end

    def get_experiment(slug)
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/experiments/#{slug}", 'GET')
      response['status'] = 200
      CLI.is_response_success(response)
      return response
    end

    def fetch_webapp_slugs(webapp_slug, slugs: nil)
      response = Cnvrg::API_V2.request("#{self.owner}/projects/#{self.slug}/webapps/#{webapp_slug}", 'GET')

      if response.key?("experiments")
        return response["experiments"]
      end
      return response["data"]["attributes"]["experiments"]
    rescue
      slugs
    end

    def update_idx_with_commit!(commit, latest: nil)
      idx_hash = self.get_idx
      idx_hash[:commit] = commit
      self.set_on_branch(latest) unless latest.nil?

      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') { |f| f.write idx_hash.to_yaml }
      return true
    end

    def revert(working_dir)
      FileUtils.rm_rf working_dir
    end

    def init_machines
      Cnvrg::Logger.log_info("Init machines.")
      resp = Cnvrg::API.request("users/#{@owner}/machines", "GET")
      return unless Cnvrg::CLI.is_response_success(resp, false)
      @machines = resp['result']['machines']
    end

    def get_machines
      init_machines if @machines.nil?
      @machines = false if @machines.nil?
      @machines || []
    end

    def update_job_jupyter_token(job_type, job_id, token)
      owner = self.owner || ENV['CNVRG_OWNER']
      slug = self.slug || ENV['CNVRG_PROJECT']
      base_url = "users/#{owner}/projects/#{slug}/jobs/#{job_type.underscore}/#{job_id}"
      Cnvrg::API.request("#{base_url}/update_jupyter_token", "POST", { token: token })
    end

    def check_machine(machine)
      Cnvrg::Logger.log_info("Check if #{machine} machine exists")
      machines = get_machines
      return true if machines.blank?
      machines.include? machine
    end

    def fetch_project
      resp = Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/get_project", "GET")
      res = JSON.parse(resp['result']) rescue nil
      return if res.blank?
      config = self.get_config
      config[:project_name] = res['title']
      config[:project_slug] = @slug
      config[:owner] = @owner
      config[:git] = res['git'] || false
      config[:is_git] = res['git'] || false
      self.set_config(config)
    end

    def job_log(logs, level: 'info', step: nil, job_type: nil, job_id: nil)
      job_type ||= ENV['CNVRG_JOB_TYPE']
      job_id ||= ENV['CNVRG_JOB_ID']
      logs = [logs].flatten
      if job_type.blank? or job_id.blank?
        raise StandardError.new("Cant find job env variables")
      end
      logs.each_slice(10).each do |temp_logs|
        Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/jobs/#{job_type.underscore}/#{job_id}/log", "POST", { job_type: job_type, job_id: job_id, logs: temp_logs, log_level: level, step: step, timestamp: Time.now })
        sleep(1)
      end
    end

    def job_commands
      job_type, job_id = ENV['CNVRG_JOB_TYPE'], ENV['CNVRG_JOB_ID']
      resp = Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/jobs/#{job_type.underscore}/#{job_id}/commands", "GET")
    end

    def spot_will_terminate
      restart = false
      config = self.get_config
      # logic that will prevent multiple restart calls
      if config[:spot_taken]
        return false
      end
      begin
        url = URI.parse('http://169.254.169.254/latest/meta-data/spot/termination-time')
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) { |http|
          http.request(req)
        }
        unless res.body.include? "404"
          restart = true
        end
        if res.body.include? "Empty reply from server"
          restart = false
        end
      rescue
        restart = false
      end

      if restart
        config[:spot_taken] = true
        self.set_config(config)
      end

      return restart
    end

    def send_restart_request(job_id: nil, job_type: nil, ma_id: nil)
      Cnvrg::API.request("#{base_resource}/spot_restart", 'POST', { job_type: job_type, job_id: job_id, machine_activity: ma_id })
    end

    def get_machine_activity
      begin
        machine_activity = File.open("#{@local_path}/.cnvrg/machine_activity", "rb").read
        machine_activity = machine_activity.to_s.strip
        ma_id = machine_activity.to_i
        return ma_id
      rescue
        return nil
      end
    end

    def set_job_pod_restart(job_type: nil, job_id: nil)
      job_type ||= ENV['CNVRG_JOB_TYPE']
      job_id ||= ENV['CNVRG_JOB_ID']
      if job_type.blank? or job_id.blank?
        raise StandardError.new("Cant find job env variables")
      end
      Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/jobs/#{job_type.underscore}/#{job_id}/set_pod_restart", "POST", { job_type: job_type, job_id: job_id })
    end

    def check_job_pod_restart(job_type: nil, job_id: nil)
      job_type ||= ENV['CNVRG_JOB_TYPE']
      job_id ||= ENV['CNVRG_JOB_ID']
      if job_type.blank? or job_id.blank?
        raise StandardError.new("Cant find job env variables")
      end
      resp = Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/jobs/#{job_type.underscore}/#{job_id}/check_pod_restart", "GET", { job_type: job_type, job_id: job_id })
      return [false, false] if resp.blank?
      Cnvrg::Logger.log_info("Checked for pod restart got response #{resp}")
      [resp['project_downloaded'], resp['dataset_downloaded']]
    end

    def pre_job_pod_restart
      job_type ||= ENV['CNVRG_JOB_TYPE']
      job_id ||= ENV['CNVRG_JOB_ID']
      if job_type.blank? or job_id.blank?
        raise StandardError.new("Cant find job env variables")
      end
      Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/jobs/#{job_type.underscore}/#{job_id}/pre_pod_restart", "POST", { job_type: job_type, job_id: job_id })
    end

    def set_job_started
      job_type ||= ENV['CNVRG_JOB_TYPE']
      job_id ||= ENV['CNVRG_JOB_ID']
      if job_type.blank? or job_id.blank?
        raise StandardError.new("Cant find job env variables")
      end
      Cnvrg::API.request("users/#{@owner}/projects/#{@slug}/jobs/#{job_type.underscore}/#{job_id}/set_started", "POST", { job_type: job_type, job_id: job_id })
    end

    def self.stop_if_project_present(project_home, project_name, owner)
      cli = Cnvrg::CLI.new()
      config = YAML.load_file(project_home + "/.cnvrg/config.yml")
      local_commit = YAML.load_file(project_home + "/.cnvrg/idx.yml")[:commit] rescue nil
      return if local_commit.blank?
      if config[:project_name] == project_name && config[:owner] == owner
        cli.log_message("Project already present, clone aborted")
        exit(0)
      end
    rescue => e
      nil
    end
  end
end
