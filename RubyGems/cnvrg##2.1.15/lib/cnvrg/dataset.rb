require 'fileutils'
module Cnvrg
  class Dataset
    attr_reader :slug, :owner, :title, :local_path, :working_dir

    RemoteURL ||= "https://cnvrg.io"
    IDXParallelThreads ||= Cnvrg::Helpers.parallel_threads
    IDXParallelProcesses ||= Parallel.processor_count

    def initialize(project_home = '', dataset_url: '', dataset_info: '')
      begin
        @info = {}
        if project_home.present?
          @local_path = project_home
          @working_dir = project_home
          config = Cnvrg::Helpers.get_config_v2_dataset(project_home)
          @title = config[:dataset_name]
          @slug = config[:dataset_slug]
          @owner = config[:owner]
        elsif dataset_info.present?
          @title = dataset_info[:slug]
          @slug = dataset_info[:slug]
          @owner = dataset_info[:owner]
          @local_path = Dir.pwd
        else
          owner, slug = Cnvrg::Helpers.extract_owner_slug_from_url(dataset_url, 'datasets')
          @title = slug
          @slug = slug
          @owner = owner
          @local_path = Dir.pwd
        end
      rescue => e

      end
    end

    def soft_linked?
      @dataset_call["dataset_type"] == "soft_link_dataset"
    end

    def init_home(remote: false)
      dataset_home = File.join(Dir.pwd, @slug)
      if Dir.exists? dataset_home
        if !remote
          Cnvrg::CLI.log_message("Error: Conflict with dir #{@slug}", Thor::Shell::Color::RED)
          if Thor::Shell::Basic.new.no? "Sync to repository anyway? (current data might lost)", Thor::Shell::Color::YELLOW
            Cnvrg::CLI.log_message("Remove dir in order to clone #{@slug}", Thor::Shell::Color::RED)
            exit(1)
          end
        end
        FileUtils.rm_rf(dataset_home)
      end

      # if Dataset.clone(owner, dataset_name, slug, remote)
      Dataset.clone(@owner, @slug, @slug, remote)
      @local_path = dataset_home
      Cnvrg::CLI.log_message('')
      true
    end

    def get_dataset(commit: nil, query: nil)
      if @dataset_call
        return @dataset_call
      end
      response = Cnvrg::API.request("users/#{owner}/datasets/#{slug}/clone", 'POST',{ commit: commit, query:query})
      Cnvrg::CLI.is_response_success(response,true)
      @dataset_call = response["result"]
      @dataset_call
    end

    def softlinked?
      get_dataset["dataset_type"] == "soft_link_dataset"
    end


    def get_storage_client
      response = Cnvrg::API.request("users/#{@owner}/datasets/#{@slug}/client", 'GET')
      if Cnvrg::CLI.is_response_success(response, false)
        client_params = response['client']
      else
        client_params = get_storage_client_fallback
      end
      Cnvrg::Downloader::Client.factory(client_params)
    end

    def get_storage_client_fallback
      response = Cnvrg::API.request("users/#{@owner}/datasets/#{@slug}/download_multi", "POST", {files: []})
      raise StandardError.new("Can't find dataset credentials") unless Cnvrg::CLI.is_response_success(response, false)
      files = response['files']
      storage = files['is_s3'] ? 's3' : 'minio'
      files['storage'] = storage
      files
    end

    def get_stats(commit: nil, query: nil)
      response = Cnvrg::API.request("users/#{@owner}/datasets/#{@slug}/clone", 'POST', {commit: commit, query: query})
      Cnvrg::CLI.is_response_success(response, true)
      response['result']
    end

    def get_clone_chunk(latest_id: nil, chunk_size: 1000, offset: 0, commit: 'latest')
      response = Cnvrg::API.request("users/#{@owner}/datasets/#{@slug}/clone_chunk", 'POST', {commit: commit, chunk_size: chunk_size, latest_id: latest_id, offset: offset})
      return nil unless Cnvrg::CLI.is_response_success(response, false)
      response['result']['files']['keys']
    end

    def backup_idx
      Cnvrg::Logger.log_info("Backup idx")
      if File.exists? "#{self.local_path}/.cnvrg/idx.yml"
        FileUtils.cp "#{self.local_path}/.cnvrg/idx.yml", "#{self.local_path}/.cnvrg/idx.yml.backup"
      else
        idx = {commit: nil, tree: {}}
        File.open("#{self.local_path}/.cnvrg/idx.yml.backup", 'w') {|f| f.write idx.to_yaml}
      end
    end

    def restore_idx
      Cnvrg::Logger.log_info("Restore idx because an error.")
      Cnvrg::Logger.log_method(bind: binding)
      idx = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml.backup")
      self.set_idx(idx)
    end

    def change_url(owner: '', slug: '', title: '')
      config = {dataset_home: title, dataset_slug: slug, owner: owner}
      File.open(".cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
    end

    def self.delete(dataset_slug, owner)
      response = Cnvrg::API.request("users/#{owner}/datasets/#{dataset_slug}/delete", 'DELETE')
      return response
    end

    def last_local_commit
      if !File.exist? "#{self.local_path}/.cnvrg/idx.yml"
        return nil
      end
      idx = YAML.load_file(@local_path + "/.cnvrg/idx.yml")
      return idx[:commit]
    end

    def snapshot
      commit = last_local_commit
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/volumes/create", 'POST', {data_commit: commit})
      CLI.is_response_success(response)
      return response
    end

    def list(owner)
      response = Cnvrg::API.request("users/#{owner}/datasets/list", 'GET')
      CLI.is_response_success(response)
      return response
    end

    def search_queries
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/queries/list", 'GET')
      CLI.is_response_success(response)
      row = [["name", "id", "created_at", "username"]]
      response["results"]["queries"].each do |query|
        row << [query["name"], query["slug"], query["created_at"].in_time_zone.to_s, query["username"]]
      end
      return row
    end

    def get_query_file(query_slug)
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/search/#{query_slug}", 'GET')
      CLI.is_response_success(response)
      row = [["Name", "Full path", "URL"]]
      response["results"]["query_files"].each do |file|
        row << [file["name"], file["fullpath"], file["s3_url"]]
      end
      return row
    end

    def download_tags_yaml
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/tags_yml", 'GET')
      CLI.is_response_success(response)
      begin
        path = self.working_dir
        File.open("#{path}/#{response["results"]["filename"]}", "w+") {|f| f.write response["results"]["file_content"]}
        return true
      rescue
        return false
      end
    end

    def list_commits(commit_sha1: nil)
      response = Cnvrg::API.request(
          "users/#{self.owner}/datasets/#{self.slug}/list_commits?commit=#{commit_sha1}",
          'GET'
      )
      CLI.is_response_success(response)
      return response
    end

    def upload_tags_via_yml(tag_file = nil)
      records_yml = YAML.load_file(tag_file)
      tag_file.close
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/data_tags_create", 'POST', {records_yml: records_yml})
      if response["status"] == 200
        return true
      else
        return false
      end
    end

    def url
      url = Cnvrg::Helpers.remote_url
      "#{url}/#{self.owner}/projects/#{self.slug}"
    end

    def self.verify_cnvrgignore_exist(dataset_name, remote)
      path = ".cnvrgignore"
      if !File.exist? path
        path = "#{dataset_name}/.cnvrgignore"
      end
      ignore_exits = File.exist? path
      if !ignore_exits
        begin
          list_files = [
              path
          ]
          FileUtils.touch list_files
          cnvrgignore = Helpers.cnvrgignore_content
          File.open(path, "w+") {|f| f.write cnvrgignore}
        rescue => e
          return false
        end

      end
    end

    def update_ignore_list(new_ignore)

      if new_ignore.nil? or new_ignore.empty?
        return true
      end
      begin
        File.open(self.local_path + "/.cnvrgignore", "a+") do |f|
          f.puts("\n")

          new_ignore.each do |i|
            f.puts("#{i}\n")
          end
        end
        return true
      rescue
        return false
      end
    end

    def get_ignore_list
      ### handle case when after clone .cnvrgignore doesnt exists
      if not File.exists?(self.local_path + "/.cnvrgignore")
        self.generate_cnvrg_ignore
      end

      ignore_list = []
      if not File.exists? "#{self.local_path}/.cnvrgignore"
        return ignore_list
      end
      File.open(self.local_path + "/.cnvrgignore", "r").each_line do |line|
        line = line.strip
        if line.start_with? "#" or ignore_list.include? line or line.empty?
          next
        end
        if line.end_with? "/" or File.directory?(line)
          ignore_list << line
          all_sub = Dir.glob("#{line}/**/*", File::FNM_DOTMATCH).flatten

          ignore_list << all_sub.flatten
        elsif line.include? "*"
          regex_list = Dir.glob("**/*#{line}", File::FNM_DOTMATCH).flatten
          ignore_list << regex_list
        else
          ignore_list << line
        end
      end
      return ignore_list.flatten
    end


    def self.init(owner, dataset_name, is_public = false, bucket: nil)
      list_dirs = [".cnvrg"
      ]
      list_files = [
          ".cnvrg/config.yml"
      ]
      create_ignore = false
      if !File.exist? ".cnvrgignore"
        list_files << ".cnvrgignore"
        create_ignore = true
      end

      cnvrgignore = Helpers.cnvrgignore_content
      begin
        response = Cnvrg::API.request("cli/create_dataset", 'POST', {title: dataset_name, owner: owner, is_public: is_public, bucket: bucket})
        Cnvrg::CLI.is_response_success(response)
        response = JSON.parse response["result"]
        dataset_slug = response["slug"]

        config = {dataset_name: dataset_name,
                  dataset_slug: dataset_slug,
                  owner: owner}

        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files
        File.open(".cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
        File.open(".cnvrgignore", "w+") {|f| f.write cnvrgignore} unless !create_ignore
      rescue => e
        return false
      end
      return true
    end

    def self.link_dataset(owner: nil, slug: nil)
      begin
        return false if owner.blank? or slug.blank?

        response = Cnvrg::API.request("users/#{owner}/datasets/#{slug}", 'GET')
        success = Cnvrg::CLI.is_response_success(response, false)
        return unless success
        result = response["result"]

        sha1 = result["init_commit_sha1"]
        
        # We need to write init IDX that contain init commit sha1 so the user will be able to doing actions on the dataset
        # so it only relevant for new server
        raise Exception.new("This feature is not available for your cnvrg version. Please contact support for more information") if sha1.blank? ## means this is old version of server

        config = {dataset_name: result["title"],
                  dataset_slug: result["slug"],
                  owner: owner}

        list_dirs = [".cnvrg"]
        list_files = [".cnvrg/config.yml"]


        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files
        File.open(".cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}

        dataset = Dataset.new(Dir.pwd)
        dataset.write_idx({}, sha1)
        true
      rescue => e
        raise Exception.new(e)
      end
    end

    def self.blank_clone(owner, dataset_name, dataset_slug)
      list_dirs = ["#{dataset_slug}/.cnvrg"
      ]
      list_files = [
          "#{dataset_slug}/.cnvrg/config.yml"
      ]
      create_ignore = false
      if !File.exist? ".cnvrgignore"
        list_files << "#{dataset_slug}/.cnvrgignore"
        create_ignore = true
      end


      cnvrgignore = Helpers.cnvrgignore_content
      begin

        config = {dataset_name: dataset_name,
                  dataset_slug: dataset_slug,
                  owner: owner}

        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files
        File.open("#{dataset_slug}/.cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
        File.open("#{dataset_slug}/.cnvrgignore", "w+") {|f| f.write cnvrgignore} unless !create_ignore
      rescue => e
        return false
      end
      return true
    end

    def generate_cnvrg_ignore
      cnvrgignore = Helpers.cnvrgignore_content
      File.open(self.local_path + "/.cnvrgignore", "w+") {|f| f.write cnvrgignore}
    end

    def self.verify_dataset(dataset_slug)
      config = YAML.load_file("/data/#{dataset_title}/.cnvrg/config.yml") rescue {}
      config[:success] == true
    end

    def self.verify_datasets(dataset_titles, timeout = nil)
      start_time = Time.now.to_i
      Cnvrg::Logger.log_info("Verifying datasets #{dataset_titles}")
      Cnvrg::Logger.log_info("Timeout is  #{timeout}")
      while true
        begin
          current_time = Time.now.to_i
          return false if (timeout.present? and timeout < current_time - start_time)
          all_are_ready = dataset_titles.all? do |dataset_title|
            config = YAML.load_file("#{dataset_title}/.cnvrg/config.yml")
            config[:success] == true
          end
          return true if all_are_ready
          Cnvrg::Logger.log_info("Sleeping..")
          sleep 10
        rescue => e
          Cnvrg::Logger.log_info("Got error")
          Cnvrg::Logger.log_error(e)
          sleep 10
        end
      end
    end

    def self.scan_datasets()
      Cnvrg::Logger.log_info("Looking up datasets")
      datasets = Dir.entries(Dir.pwd).map do |entry|
        if File.directory? File.join(Dir.pwd,entry) and !(entry =='.' || entry == '..')
          begin
            config = YAML.load_file("#{Dir.pwd}/#{entry}/.cnvrg/config.yml") rescue nil
            local_commit = YAML.load_file("#{Dir.pwd}/#{entry}/.cnvrg/idx.yml")[:commit] rescue nil
            if config.present? and config[:success] == true and config[:dataset_name].present? and config[:dataset_slug].present? and local_commit.present?
              {
                  "dataset_slug": config[:dataset_slug],
                  "dataset_name": config[:dataset_name],
                  "local_commit": local_commit,
              }
            else
              nil
            end
          rescue
            nil
          end
        end
      end.compact.uniq
      datasets
    end

    def clone(commit)
      return
    end

    def self.clone(owner, dataset_name, dataset_slug, remote = false)
      begin
        list_dirs = []
        if !remote
          list_dirs << dataset_name
        end
        list_dirs << "#{dataset_name}/.cnvrg"
        list_files = [
            "#{dataset_name}/.cnvrg/config.yml",
        ]

        config = {dataset_name: dataset_name,
                  dataset_slug: dataset_slug,
                  owner: owner}


        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files
        File.open("#{dataset_name}/.cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}
      rescue => e
        puts "Exception in clone request:#{e.message}"
        return false
      end
      return true
    end

    def list_files(commit_sha1: "latest", limit: 1000, offset: 0, expires: 3600)
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/list", 'GET', {commit_sha1: commit_sha1, limit: limit, offset: offset, expires: expires})
      return nil if response.blank?
      response.to_json
    end

    def self.clone_tree(commit: 'latest', dataset_home: nil, progressbar: nil)
      @dataset = Cnvrg::Dataset.new(dataset_home)
      @files = Cnvrg::Datafiles.new(@dataset.owner, @dataset.slug, dataset: @dataset)
      trees = @files.get_trees(commit: commit)
      return false if trees.nil?

      if progressbar
        pb = progressbar
        pb.total += trees.size
      else
        pb = ProgressBar.create(
          :title => "Download Progress",
          :progress_mark => '=',
          :format => "%b>>%i| %p%% %t",
          :starting_at => 0,
          :total => trees.size,
          :autofinish => true
        )
      end

      trees.each do |tree|
        pb.progress += 1
        @files.download_dir(dataset_home, tree)
      end

      unless progressbar
        # if progessbar sent it means that its not only tree so we dont want to finish the progress bar
        # and we dont want to write success

        pb.finish
        @dataset.write_success
      end
      true
    end

    def write_success(in_folder = false)
      file_path = ".cnvrg/config.yml"
      file_path = File.join(@local_path || @working_dir, file_path)
      if File.exist?(file_path)
        File.open(file_path, "a") {|f| f.puts(":success: true")}
      end
    end

    def self.init_container(owner, dataset_slug, dataset_name)

      cnvrgignore = Helpers.cnvrgignore_content
      begin
        list_dirs = [".cnvrg"
        ]
        list_files = [
            ".cnvrgignore",
            ".cnvrg/config.yml"
        ]
        FileUtils.mkdir_p list_dirs
        FileUtils.touch list_files

        config = {dataset_name: dataset_name,
                  dataset_slug: dataset_slug,
                  owner: owner}
        File.open(".cnvrg/config.yml", "w+") {|f| f.write config.to_yaml}

        File.open(".cnvrgignore", "w+") {|f| f.write cnvrgignore} unless File.exist? ".cnvrgignore"
      rescue => e
        return false
      end
      return true
    end


    def get_idx
      if File.exists? "#{self.local_path}/.cnvrg/idx.yml"
        return YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      end
      {commit: nil, tree: {}}
    end

    def set_idx(idx)
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w+') {|f| f.write idx.to_yaml}
    end

    def url
      url = Cnvrg::Helpers.remote_url
      "#{url}/#{self.owner}/datasets/#{self.slug}"
    end

    def generate_chunked_idx(list_files = [], threads: 15, prefix: '', cli: nil)
      tree = {}
      Parallel.map(list_files, in_threads: threads) do |file|

        # Fix for root path issue
        safe_path = file
        safe_path = file[1..-1] if file.start_with? "/"

        dataset_local_path = self.local_path + "/"
        label = safe_path.start_with?(dataset_local_path) ? safe_path.sub(dataset_local_path, "") : safe_path
        label = "#{prefix}/#{label}" if prefix.present?
        if not Cnvrg::Files.valid_file_name?(label)
          if cli
            cli.log_message("#{label} is not a valid file name, skipping it", Thor::Shell::Color::RED)
          else
            puts "#{label} is not a valid file name, , skipping it"
          end
        end
        if File.directory? file
          tree[label + "/"] = nil
        else
          begin
            sha1 = OpenSSL::Digest::SHA1.file(file).hexdigest
          rescue => e
            #puts "Could'nt calculate sha1 for: #{file}, Error: #{e.message}"
            next
          end
          file_name = File.basename file
          file_size = File.size(file).to_f
          mime_type = MimeMagic.by_path(file)
          content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"
          relative_path = safe_path.gsub(/^#{@local_path + "/"}/, "")
          relative_path = "#{prefix}/#{relative_path}" if prefix.present?
          tree[label] = {
            sha1: sha1,
            file_name: file_name,
            file_size: file_size,
            content_type: content_type,
            absolute_path: file,
            relative_path: relative_path
          }
        end
      end

      if prefix.present? #add the prefix as dirs to the files
        #lets say the prefix is a/b/c so we want that a/, a/b/, a/b/c/ will be in our files_list
        dirs = prefix.split('/')
        curr_path = []
        dirs.each do |dir|
          curr_path << dir
          list_files << curr_path.join('/')
        end
      end
      return tree
    end

    def revert_to_last_commit(commit: nil)
      if commit.blank?
        resp = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/last_valid_commit", 'GET')
        if CLI.is_response_success(resp, false)
          commit = resp['result']['commit_sha1']
        end
      end
      self.update_idx_with_commit(commit) if commit.present?
      self.revert_next_commit
    end

    def list_all_files(with_ignore = false)
      list = Dir.glob("#{self.local_path}/**/*", File::FNM_DOTMATCH).reject {|x| (x =~ /\/\.{1,2}$/) or (x =~ /^#{self.local_path}\/\.cnvrg\/*/) or (x =~ /^#{self.local_path}\/\.cnvrgignore.conflict*/) and not (x =~ /^#{self.local_path}\/\.cnvrgignore/)}

      #we want that big files will
      list = list.sort_by {|fn| File.size(fn)}
      return list if with_ignore
      list_ignore = self.get_ignore_list.map {|ignore_file| "#{self.local_path}/#{ignore_file}"}
      (list - list_ignore)
    end

    def write_idx(tree = nil, commit = nil)
      if tree.nil?
        tree = self.generate_idx[:tree]
        tree = tree.map {|k, v| (v.present?) ? [k, {sha1: v[:sha1], commit_time: Time.now}] : [k, v]}.to_h
      end
      idx = {tree: tree, commit: commit}
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx.to_yaml}
    end

    def write_tree(tree)
      idx = self.get_idx
      idx[:tree] = tree
      self.set_idx(idx)
    end

    def generate_idx(show_progress = false)
      if File.exists? "#{self.local_path}/.cnvrg/idx.yml"
        old_idx = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      else
        old_idx = nil
      end
      tree_idx = Hash.new(0)
      list = Dir.glob("#{self.local_path}/**/*", File::FNM_DOTMATCH).reject {|x| (x =~ /\/\.{1,2}$/) or (x =~ /^#{self.local_path}\/\.cnvrg\/*/) or (x =~ /^#{self.local_path}\/\.cnvrgignore.conflict*/) and not (x =~ /^#{self.local_path}\/\.cnvrgignore/)}
      list_ignore = self.get_ignore_list()
      if show_progress
        parallel_options = {
            :progress => {
                :title => "Checking Dataset",
                :progress_mark => '=',
                :format => "%b>>%i| %p%% %t",
                :starting_at => 0,
                :total => (list).size,
                :autofinish => true
            },
            in_threads: IDXParallelThreads,
            isolation: true
        }
      else
        parallel_options = {
            in_threads: IDXParallelThreads,
            isolation: true
        }
      end

      Parallel.map(list, parallel_options) do |e|
        label = e.gsub(self.local_path + "/", "")
        if File.directory? e
          if list_ignore.include? label
            next
          end
          tree_idx[label + "/"] = nil
        else
          if list_ignore.include? label
            next
          end
          sha1 = OpenSSL::Digest::SHA1.file(e).hexdigest
          if old_idx.nil? or old_idx.to_h["tree"].nil?
            tree_idx[label] = {sha1: sha1, commit_time: nil}
          elsif old_idx["tree"][label].nil? or old_idx["tree"][label]["sha1"] != sha1
            tree_idx[label] = {sha1: sha1, commit_time: nil}
          else
            tree_idx[label] = old_idx["tree"][label]
          end
        end
      end
      if !old_idx.nil? and !old_idx[:next_commit].nil? and !old_idx[:next_commit].empty?
        idx = {commit: old_idx.to_h[:commit], tree: tree_idx, next_commit: old_idx[:next_commit]}
      else
        idx = {commit: old_idx.to_h[:commit], tree: tree_idx}
      end
      idx_yaml = idx.to_yaml
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx_yaml}
      return idx
    end

    def create_volume
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/volumes/create", 'POST')
      CLI.is_response_success(response)
      return response
    end

    def download_updated_data(current_commit)
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/download_updated_data", 'POST', {current_commit: current_commit})
      CLI.is_response_success(response, false)
      return response
    end

    def compare_idx(new_branch, commit = last_local_commit, local_idx = nil, force = false, next_commit = nil)
      if local_idx.nil?
        local_idx = self.generate_idx
      end
      ignore_list = self.get_ignore_list()
      if force
        added = []
        if local_idx[:tree]
          added << local_idx[:tree].keys
          added.flatten!
        end

        response = {"result" => {"commit" => next_commit, "tree" => {"added" => added,
                                                                     "updated_on_server" => [],
                                                                     "updated_on_local" => [],
                                                                     "deleted" => [],
                                                                     "conflicts" => []}}}
        return response

      end
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/status", 'POST', {idx: local_idx, new_branch: new_branch, current_commit: commit, ignore: ignore_list, next_commit: next_commit})
      CLI.is_response_success(response, false)
      return response
    end

    def compare_idx_download(all_files: false, desired_commit: nil)
      current_commit = self.last_local_commit
      next_commit = self.get_next_commit
      ignore_list = self.send_ignore_list()
      return Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/download_status", 'POST', {current_commit: current_commit, next_commit: next_commit, ignore: ignore_list, all_files: all_files, desired_commit: desired_commit.presence})
    end

    def set_partial_commit(commit_sha1)
      idx = self.get_idx
      idx[:partial_commit] = commit_sha1
      self.set_idx(idx)
    end

    def get_partial_commit
      idx = self.get_idx
      idx.try(:fetch, :partial_commit)
    end

    def current_status(new_branch)
      commit = last_local_commit
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/status_current", 'POST', {current_commit: commit, new_branch: new_branch})
      CLI.is_response_success(response, true)
      return response
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


    def compare_commits(commit)
      response = Cnvrg::API.request("users/#{self.owner}/datasets/#{self.slug}/compare_commits", 'POST', {compare_commit: commit, current_commit: last_local_commit})
      CLI.is_response_success(response, false)
      return response
    end

    def set_next_commit(commit_sha1)
      if !File.exist? "#{self.local_path}/.cnvrg/idx.yml"
        idx_hash = Hash.new()
        idx_hash[:commit] = ""
        idx_hash[:tree] = ""
      else
        idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      end
      idx_hash[:next_commit] = commit_sha1
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx_hash.to_yaml}
      return true

    end

    def get_next_commit()
      if !File.exist? "#{self.local_path}/.cnvrg/idx.yml"
        return nil
      end
      idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      return idx_hash[:next_commit]
    end

    def remove_next_commit()
      if !File.exist? "#{self.local_path}/.cnvrg/idx.yml"
        return nil
      end
      idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      idx = Hash.new()
      idx[:commit] = idx_hash[:next_commit]
      idx[:tree] = idx_hash[:tree]
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx.to_yaml}
    end

    def revert_next_commit()
      if !File.exist? "#{self.local_path}/.cnvrg/idx.yml"
        return nil
      end
      idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      idx_hash = idx_hash.except(:next_commit)
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx_hash.to_yaml}
    end

    def compare_commit(commit)
      if commit.nil? or commit.empty?
        commit = last_local_commit
      end
      response = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/commit/compare", 'POST', {current_commit: commit})
      CLI.is_response_success(response, false)
      update_is_new_branch(response["result"]["new_branch"])
      return response["result"]["new_branch"]
    end

    def update_idx_with_files_commits!(files, commit_time)
      # files.flatten!
      idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      # idx_hash[:commit] = commit

      files.each do |path|
        idx_hash[:tree].to_h[path].to_h[:commit_time] = commit_time
      end
      idx_hash[:next_commit] = idx_hash[:next_commit]
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx_hash.to_yaml}

      return true
    end

    def update_idx(idx)
      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx.to_yaml}
      return true
    end

    def update_idx_with_commit!(commit)
      idx_hash = YAML.load_file("#{self.local_path}/.cnvrg/idx.yml")
      idx_hash[:commit] = commit

      File.open("#{self.local_path}/.cnvrg/idx.yml", 'w') {|f| f.write idx_hash.to_yaml}
      return true
    end

    def revert(working_dir)
      FileUtils.rm_rf working_dir
      # response     = Cnvrg::API.request("users/#{self.owner}/projects/#{self.slug}/revert", 'GET')
      # CLI.is_response_success(response)
    end

    def self.validate_config
      ## check that the .cnvrg folder exists:
      dot_cnvrg_exists = Dir[".cnvrg"].present?
      return {validation: Data::ConfigValidation::FAILED, message: ".cnvrg folder does not exists"} if not dot_cnvrg_exists

      ## check that the config.yml exists:
      config_file_exists = Dir[".cnvrg/*"].include? ".cnvrg/config.yml"
      return {validation: Data::ConfigValidation::FAILED, message: "config.yml exists"} if not config_file_exists

      ## check that the config.yml file not empty:
      config = YAML.load_file("#{Dir.getwd}/.cnvrg/config.yml")
      return {validation: Data::ConfigValidation::FAILED, message: "config.yml is empty"} if not config

      ## check that config.yml is valid:
      title = config[:dataset_name]
      slug = config[:dataset_slug]
      owner = config[:owner]
      return {validation: Data::ConfigValidation::FAILED, message: "config.yml is not valid or some keys are missing"} if title.blank? or slug.blank? or owner.blank?

      ## everything OK:
      return {validation: Data::ConfigValidation::SUCCESS, message: "Directory is already linked to #{slug}"}
    end

    def self.stop_if_dataset_present(dataset_home, dataset_name, commit: nil)
      cli = Cnvrg::CLI.new()
      config = YAML.load_file(dataset_home + "/.cnvrg/config.yml")
      if config[:dataset_name] == dataset_name
        cli.log_message("Dataset already present, clone aborted")
        exit(0)
      end
    rescue => e
      nil
    end
  end
end
