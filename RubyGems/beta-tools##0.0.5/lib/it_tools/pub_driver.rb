#!/usr/bin/env ruby

require_relative 'html_publish'
require_relative 'network_tools'
require_relative 'publisher2'
require 'logger'
require 'optparse'

module PubDriver
  class Pub
    attr_accessor :ops
    def initialize( ops = {} )
      @ops = {}
      @ops.merge! ops
      @log = Logger.new('log.txt')
      if level = @ops[:debug_level]
        @log.level = level
        @log.debug "Set logger to debug."
      else
        @log.level = Logger::INFO
        @log.info "Set logger to info."
      end
    end
    def validate( options, required, values ) 
      missing_msg = "Missing required parameter: '"
      required.each do |entry|
        value = values[entry]
        raise missing_msg + value[:short] + "', or '" + value[:long] + "', which specifies the " + value[:mesg] unless options[entry]
      end
    end
    def publish_locally2
      options = get_local_pub_options
      solr_search_files = [ "search.html",
                            "search.js",
                            "ajax-loader.gif",
                            "help.png" ]

      parameters = { 
        :solr_base_url => "http://searcher:8983/solr/",
        :style_sheet => "inputStyles.css",
        :solr_search_files => solr_search_files,
        :src_dir => options[:src_dir],
        :target_dir => options[:solr_dir],
        :static_dir => options[:static_dir],
        :debug_level => options[:debug_level],
        :solr_search_files_dir => options[:solr_search_files_dir],
        :search_category => options[:search_category] }
      
      @log.debug "Params: " + parameters.to_s
      publisher = Publisher::Markdown.new parameters
      publisher.process_files
    end
    def publish_locally
      solr_indexer = "http://127.0.0.1:8983/solr/"
      converter = Website::MarkdownConverter.new :indexer_url => solr_indexer
      converter.go
    end
    def validate_local_publish options
      dir_counts, ext_counts = count_files_in_dir options, [:src_dir, :solr_dir, :static_dir], ['.mmd']
      dir_count_printer = lambda { |key,count,hash| p hash[key] + ": [#{count}]" }
      print_counts dir_counts, dir_count_printer
      print_counts ext_counts, options
    end
    def print_counts hash, printer
      hash.each do |key,value|
        printer.call key, value, hash
      end
    end
    def count_files_in_dir options, dirs, extension = []
      file_count = {}
      ext_count = {}
      dirs.each do |dir|
        file_count[dir] = Dir.entries(options[dir]).size - 2
        next unless extension.size > 0
        files_with_extension_count = {}
        extension.each do |curr_ext|
          ext_count[curr_ext] = 0
        end
        Dir.entries(options[dir]).each do |file|
          full_path = File.join options[dir], file
          next unless File.exists? full_path
          next if File.directory? full_path
          extension.each do |curr_ext|
            if (File.extname file) == curr_ext
              ext_count[curr_ext] += 1
            end
          end
        end
        return [file_count,ext_count]
      end
    end
    def rsync_it ops
      command = "rsync -avP --stats #{ops[:from_dir]} "
      command += "#{ops[:as_user]}@" if ops[:as_user]
      command += "#{ops[:to_host]}:#{ops[:to_dir]} "
      p "[command]: " + command
      system command
    end

    def publish_remote params
      vpnTools = NetworkTools::VpnTools.new
      rsync_ops = {}
      rsync_ops[:from_dir] = params[:doc]
      rsync_ops[:as_user] = params[:as_user]
      if vpnTools.on_vpn
        @log.debug "On VPN, so sync'ing regular docs AND work docs"
        rsync_ops[:to_host] = params[:int_host]

        rsync_ops[:to_dir] = params[:int_docs]
        rsync_it rsync_ops

        rsync_ops[:from_dir] = params[:wdoc]
        rsync_ops[:to_dir] = params[:int_wdocs]
        rsync_it rsync_ops
      else
        @log.debug "On VPN, so only sync'ing regular docs."
        rsync_ops[:to_host] = params[:ext_host]
        rsync_ops[:to_dir] = params[:ext_docs]
        rsync_it rsync_ops
      end
    end
    def get_local_pub_options
      options = {}
      src = { :short => '-s', :long => '--src_dir DIR', :mesg => 'Directory of source markdown files.'}
      solr = { :short => '-w', :long => '--solr_write_dir DIR', :mesg => 'Directory to write solr files.'}
      stat = { :short => '-t', :long => '--static_html_dir DIR', :mesg => 'Directory to write static html files.'}
      solr_search = { :short => '-l', :long => '--solr_search_files_dir DIR', :mesg => 'Directory to read solr search files from.'}

      values = { :src_dir => src, :solr_dir => solr, :static_dir => stat, :ssf => solr_search }
      optparse = OptionParser.new do |opts|
        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end
        curr_opt = values[:src_dir]
        opts.on( curr_opt[:short], curr_opt[:long], curr_opt[:mesg] ) do |dir|
          @log.debug "Setting source directory for markdown files."
          raise "Directory not specified! " + curr_opt[:mesg] if dir.nil?
          raise "Can't find markdown source dir as specified #{dir}" unless File.directory? dir
          options[:src_dir] = dir
        end
        curr_opt = values[:solr_dir]
        opts.on( curr_opt[:short], curr_opt[:long], curr_opt[:mesg] ) do |dir|
          raise "Directory not specified! " + curr_opt[:mesg] if dir.nil?
          FileUtils.mkdir dir unless File.exists? dir
          options[:solr_dir] = dir
        end
        curr_opt = values[:static_dir]
        opts.on( curr_opt[:short], curr_opt[:long], curr_opt[:mesg] ) do |dir|
          raise "Directory not specified! " + curr_opt[:mesg] if dir.nil?
          FileUtils.mkdir dir unless File.exists? dir
          options[:static_dir] = dir
        end
        curr_opt = values[:ssf]
        opts.on( curr_opt[:short], curr_opt[:long], curr_opt[:mesg] ) do |dir|
          raise "Directory not specified! " + curr_opt[:mesg] if dir.nil?
          FileUtils.mkdir dir unless File.exists? dir
          options[:solr_search_files_dir] = dir
        end

        mesg = "Specify the search category: 'public', 'work', etc..."
        opts.on( '-c', '--index_category CATEGORY', mesg ) do |category|
          raise "Missing Field: " + mesg if category.nil?
          options[:search_category] = category
        end

        mesg = "Set to 'info' or 'debug'"
        opts.on( '-d', '--debug_level LEVEL', mesg ) do |level|
          raise "Debug level not specified! #{mesg}" if level.nil?
          case level
            when "info"
            options[:debug_level] = Logger::INFO
            @log.level = Logger::INFO
            when "debug"
            options[:debug_level] = Logger::DEBUG
            @log.level = Logger::DEBUG
            else
            raise "Debug level not specified properly! #{mesg}"
          end
        end
      end
      optparse.parse!
      validate(options, [:src_dir, :solr_dir, :static_dir], values)
      @ops.merge! options
      return options
    end
  end
end
