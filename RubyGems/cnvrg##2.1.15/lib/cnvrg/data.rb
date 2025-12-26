require 'cnvrg/cli'
require 'thor'
class SubCommandBase < Thor
 def self.banner(command, namespace = nil, subcommand = false)
  "#{basename}  #{command.usage}"
 end

 def self.subcommand_prefix
  self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
 end
end

module Cnvrg
  class Data < SubCommandBase
    class_option :no_compression, :type => :boolean, :aliases => ["-nc", "--no_compression"], :default => false

    module ConfigValidation
      SUCCESS = "success"
      FAILED = "failed"
    end

    desc "data init", "Set current directory as dataset directory"
    method_option :public, :type => :boolean, :aliases => ["-p", "--public"], :default => false
    method_option :bucket, :type => :string, :aliases => ["-b", "--bucket"], :default => ""
    method_option :title, :type => :string, :aliases => ["-t", "--title"], :default => ""

    def init
      cli = Cnvrg::CLI.new()
      public = options["public"]
      bucket = options["bucket"]
      title = options["title"]
      cli.init_data(public, bucket: bucket, title: title)
    end

    desc "data link DATASET_SLUG", "Set current directory as dataset directory"
    def link(dataset=nil)
      begin
        cli = Cnvrg::CLI.new()
        cli.verify_logged_in(false)
        cli.log_start(__method__, args, options)
        
        if dataset.include? "/"
          ## this case is to support DATASET_URL expected example: domain.com/organization_name/datasets/dataset_name
          url_parts = dataset.split("/")
          dataset_index = Cnvrg::Helpers.look_for_in_path(dataset, "datasets")
          dataset_slug = url_parts[dataset_index + 1]
          owner = url_parts[dataset_index - 1]
          raise Exception.new("Can't find all dataset information please check the URL") if dataset_slug.blank? or owner.blank?
        else
          ## this case is to support DATASET_SLUG expected example: dataset_name
          # in this case it will take the organization from the config file
          dataset_slug = dataset
          raise Exception.new("Please enter dataset name or dataset full url") if dataset_slug.blank?
          owner = CLI.get_owner
        end

        config_validation = Dataset.validate_config
        if config_validation[:validation] == Data::ConfigValidation::SUCCESS
          cli.log_message(config_validation[:message])
          return
        else
          Cnvrg::Logger.log_error_message(config_validation)
          FileUtils.rmtree(".cnvrg")
        end

        cli.log_message("Linking dataset: #{dataset_slug} to the current directory", Thor::Shell::Color::BLUE)
        success = Dataset.link_dataset(owner: owner, slug: dataset_slug)
        if success
          cli.log_message("Dataset: #{dataset_slug} linked successfully to the current directory")
        else
          cli.log_message("Linking failed\nAborting", Thor::Shell::Color::RED)
        end
      rescue => e
        Cnvrg::Logger.log_error(e)
        cli.log_message("Aborting\n#{e.message}", Thor::Shell::Color::RED)
        exit(1)
      rescue Exception => e
        Cnvrg::Logger.log_error(e)
        cli.log_message("Aborting\n#{e.message}", Thor::Shell::Color::RED)
        exit(1)
      end
    end

    desc "data upload", "Upload files from local dataset directory to remote server", :hide => true
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s","--sync"], :default => false
    method_option :tags, :type => :boolean, :aliases => ["--tags"], :desc => "upload file tags", :default => false
    method_option :chunk_size, :type => :numeric, :aliases => ["--chunk"], :desc => "upload file tags", :default => 1000
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil

    def upload
      cli = Cnvrg::CLI.new()
      verbose = options["verbose"]
      sync = options["sync"]
      force = options["force"]
      new_branch = options["new_branch"]
      chunk_size = options["chunk_size"]
      tags = options["tags"]
      message = options["message"]
      cli.upload_data_new(new_branch, verbose, sync, force, tags, chunk_size, message:message)
    end
    desc 'data sync', 'Synchronise local dataset directory with remote server', :hide => true
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits"
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :commit, :type => :string, :aliases => ["-c"], :desc => "download specified commit", :default => nil
    method_option :all_files, :type => :boolean, :aliases => ["--all"], :desc => "download specified commit", :default => false
    method_option :tags, :type => :boolean, :aliases => ["--tags"], :desc => "upload file tags", :default => false
    method_option :parallel, :type => :numeric, :aliases => ["-p", "--parallel"], :desc => "uparallel upload at the same time", :default => 15
    method_option :chunk_size, :type => :numeric, :aliases => ["--chunk_size"], :desc => "chunk size to communicate with the server", :default => 1000
    method_option :init, :type => :boolean, :aliases => ["--initial"], :desc => "initial upload of dataset", :default => false
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil

    def sync_data_new()
      cli = Cnvrg::CLI.new()
      force = options["force"]
      new_branch = options["new_branch"]
      verbose = options["verbose"]
      commit = options["commit"]
      all_files = options["all_files"]
      tags = options["tags"]
      parallel=options["parallel"]
      chunk_size = options["chunk_size"]
      init = options["init"]
      message = options["message"]
      cli.sync_data_new(new_branch, force, verbose, commit, all_files, tags, parallel, chunk_size, init, message)
    end

    desc 'data download', 'Download files from remote server'
    method_option :new_branch, :type => :boolean, :aliases => ["-nb"], :desc => "create new branch of commits", :default => false
    method_option :verbose, :type => :boolean, :aliases => ["-v"], :default => false
    method_option :sync, :type => :boolean, :aliases => ["-s"], :default => false
    method_option :commit, :type => :string, :aliases => ["-c"], :desc => "download specified commit", :default => nil
    method_option :all_files, :type => :boolean, :aliases => ["--all"], :desc => "download specified commit", :default => false

    def download()
      cli = Cnvrg::CLI.new()
      verbose = options["verbose"]
      sync = options["sync"]
      new_branch = options["new_branch"]
      commit = options["commit"]
      all_files = options["all_files"]
      cli.download_data_new(verbose,sync,new_branch, commit,all_files)
    end
    desc 'data clone DATASET_URL', 'Clone dataset'
    method_option :only_tree, :type => :boolean, :aliases => ["-t", "--tree"], :default => false
    method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :default => nil
    method_option :query, :type => :string, :aliases => ["-q", "--query"], :default => nil
    method_option :read, :type => :boolean, :aliases => ["-r", "--read"], :default => false
    method_option :remote, :type => :boolean, :aliases => ["-h", "--remote"], :default => false
    method_option :relative, :type => :boolean, :aliases => ["-rel", "--relative"], :default => false
    method_option :flatten, :type => :boolean, :aliases => ["-f", "--flatten"], :default => false
    method_option :soft, :type => :boolean, :aliases => ["-s", "--soft"], :default => false, :hide => true
    method_option :threads, :type => :numeric, :aliases => ["--threads"], :default => 15
    method_option :cache_link, :type => :boolean, :aliases => ["--cache_link"], :default => false, :hide => true
    def clone(dataset_url)
      cli = Cnvrg::CLI.new()
      only_tree =options[:only_tree]
      commit =options[:commit]
      query =options[:query]
      read = options[:read]
      remote = options[:remote]
      soft = options[:soft]
      flatten = options[:flatten]
      threads = options[:threads]
      cache_link = options[:cache_link]
      cli.clone_data(
          dataset_url,
          only_tree=only_tree,
          commit=commit,
          query=query,
          read=read,
          remote=remote,
          flatten: flatten,
          relative: options[:relative],
          soft: soft,
          threads: threads,
          cache_link: cache_link
      )
    end

    desc 'data verify DATASETS_TITLES', 'verify datasets', :hide => true
    method_option :timeout, :type => :numeric, :aliases => ["-t", "--timeout"], :desc => "Time to wait before returning final answer", :default => nil
    def verify(*dataset_titles)
      cli = Cnvrg::CLI.new()
      timeout =options[:timeout]
      cli.verify_datasets(dataset_titles, timeout)
    end

    desc 'data scan', 'lookup datasets', :hide => true
    def scan()
      cli = Cnvrg::CLI.new()
      cli.scan_datasets()
    end

    desc "data block DATASET_TITLES", 'verifying that datasets exists', hide: true
    def block(*dataset_slugs)
      not_verified = true
      while not_verified
        not_verified = dataset_slugs.select{|slug| not Dataset.verify_dataset(slug)}.present?
      end
    end

    desc 'data set --url=DATASET_URL', 'Set dataset url to other url'
    method_option :url, :type => :string, :aliases => ["--url"], :default => ''
    def set
      cli = Cnvrg::CLI.new
      cli.log_start(__method__)
      cli.log_handler
      if options['url'].present?
        cli.set_data_url(options['url'])
      end
    end

    desc 'data put DATASET_URL FILES_PREFIX', 'Upload selected files from local dataset directory to remote server'
    method_option :dir, :type => :string, :aliases => ["-d", "--dir"], :default => ''
    # method_option :commit, :type => :string, :aliases => ["-c", "--commit"], :default => ''
    method_option :force, :type => :boolean, :aliases => ["-f","--force"], :default => false
    method_option :override, :type => :boolean, :aliases => ["--override"], :default => false
    method_option :threads, :type => :numeric, :aliases => ["-t","--threads"], :default => 15
    method_option :chunk_size, :type => :numeric, :aliases => ["-cs","--chunk"], :default => 1000
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil
    method_option :auto_cache, :type => :boolean, :aliases => ["--auto_cache"], :desc => "auto_cache", :default => false
    method_option :external_disk, :type => :string, :aliases => ["--external_disk"], :desc => "external_disk_title", :default => nil

    def put(dataset_url, *files)
      cli = Cnvrg::CLI.new()
      dir = options[:dir]
      force = options[:force]
      override = options[:override]
      # commit = options[:commit]
      commit = ''
      message = options[:message]
      threads = options[:threads]
      chunk_size = options[:chunk_size]
      auto_cache = options[:auto_cache]
      external_disk = options[:external_disk]
      cli.data_put(
        dataset_url,
        files: files,
        dir: dir,
        commit: commit,
        force: force,
        override: override,
        threads: threads,
        chunk_size: chunk_size,
        message: message,
        auto_cache: auto_cache,
        external_disk: external_disk
      )
    end

    desc 'data rm DATASET_URL FILES_PREFIX', 'Delete selected files from remote server'
    method_option :message, :type => :string, :aliases => ["--message"], :desc => "create commit with message", :default => nil
    method_option :auto_cache, :type => :boolean, :aliases => ["--auto_cache"], :desc => "auto_cache", :default => false
    method_option :external_disk, :type => :string, :aliases => ["--external_disk"], :desc => "external_disk_title", :default => nil
    def rm(dataset_url, *regex_list)
      cli = Cnvrg::CLI.new()
      message = options[:message]
      auto_cache = options[:auto_cache]
      external_disk = options[:external_disk]
      cli.data_rm(
        dataset_url,
        regex_list: regex_list,
        message: message,
        auto_cache: auto_cache,
        external_disk: external_disk
      )
    end

    desc 'data clone_query --query=QUERY_SLUG DATASET_URL', 'Clone dataset with specific query'
    method_option :query, :type => :string, :aliases => ["-q", "--query"], :default => nil
    method_option :soft, :type => :boolean, :aliases => ["-s", "--soft"], :default => false, :hide => true
    method_option :flatten, :type => :boolean, :aliases => ["-f", "--flatten"], :default => false
    def clone_query(dataset_url)
      cli = Cnvrg::CLI.new()
      query = options[:query]
      flatten = options[:flatten]
      soft =options[:soft]
      cli.clone_data_query(dataset_url,query=query, flatten, soft: soft)
    end

    desc 'data delete DATASET_SLUG', 'Delete dataset'
    def delete(dataset_slug)
      cli = Cnvrg::CLI.new()
      cli.delete_data(dataset_slug)

    end
    desc 'data list', 'Show list of all datasets'
    def list()
      cli = Cnvrg::CLI.new()

      cli.list_dataset()

    end

    desc 'data commits URL/SLUG', 'List all commits for a given dataset'
    method_option :commit_sha1, :type => :string, :aliases => ["-c", "--commit"], :default => nil
    def commits(dataset_url)
      cli = Cnvrg::CLI.new()
      commit_sha1 = options[:commit_sha1]
      cli.list_dataset_commits(dataset_url, commit_sha1:commit_sha1)
    end

    desc 'data files DATASET_URL', 'Show list of dataset files'
    method_option :offset, :type => :numeric, :aliases => ["-o", "--offset"], :default => 0
    method_option :limit, :type => :numeric, :aliases => ["-l", "--limit"], :default => 1000
    method_option :expires, :type => :numeric, :aliases => ["-ex", "--expires"], :default => 3600
    method_option :commit_sha1, :type => :string, :aliases => ["-c", "--commit"], :default => nil
    def files(dataset_url)
      cli = Cnvrg::CLI.new()
      cli.verify_logged_in(false)
      cli.log_start(__method__, args, options)
      @dataset = Dataset.new(dataset_url: dataset_url)
      files = @dataset.list_files(
          commit_sha1: options[:commit_sha1],
          limit: options[:limit],
          expires: options[:expires],
          offset: options[:offset])
      cli.log_message(files)
    end

    desc 'data queries', 'List all dataset queries related to current dataset'
    def queries()
      cli = Cnvrg::CLI.new()
      cli.queries()
    end

    desc 'data query_files QUERY_NAME', 'Show list of all files in specific query'
    def query_files(query)
      cli = Cnvrg::CLI.new()
      cli.query_files(query)
    end

    desc 'data download_tags_yaml', 'Download dataset tags yml files in current dataset directory'
    def download_tags_yaml
      cli = Cnvrg::CLI.new()
      cli.download_tags_yaml()
    end


    desc 'data test', 'test client'
    def test(data_url)
      cli = Cnvrg::CLI.new
      cli.verify_logged_in(true)
      cli.log_start(__method__, args, options)
      @dataset = Dataset.new(dataset_url: data_url)
      resp = @dataset.get_storage_client
      @dataset.init_home(remote: false)
      @dataset.download_softlink

    end

  end
end
