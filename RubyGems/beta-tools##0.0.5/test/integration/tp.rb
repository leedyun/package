#!/usr/bin/env ruby
require 'fileutils'
path_root = "../../lib/it_tools"
require_relative "#{path_root}/html_publish"
require_relative "#{path_root}/network_tools"
require_relative "#{path_root}/options"

class Publisher
  attr_accessor :ops, :debug, :params, :log
  def initialize
    @ops = Options.new.options
    @debug = @ops[:debug]
    @params = {
      :indexer_url => 'http://127.0.0.1:8983/solr/',
      :read_from_dir => '/home/fenton/projects/documentation',
      :write_to_dir_for_indexing => '/home/fenton/bin/website',
      :write_to_dir_with_style_for_standalone => '/home/fenton/bin/website_with_style'
    }
    @log = Logger.new('log.txt')
    if level = @ops[:debug_level]
      @log.level = level
    else
      @log.level = Logger::DEBUG
    end
  end 

  def test_go
    converter = Website::MarkdownConverter.new params
    converter.go
  end
  def test_process_files
    converter = Website::MarkdownConverter.new params
    read_dir = @params[:read_from_dir]
    write_dir = @params[:write_to_dir_for_indexing]
    static_dir = @params[:write_to_dir_with_style_for_standalone]
    files_to_process, all_files = converter.get_files_to_process read_dir, write_dir
    @params[:for_indexer_dir] = write_dir
    @params[:for_static_files_dir] = static_dir
    converter.process_files files_to_process, read_dir, @params
    converter.create_index(all_files, static_dir)
    converter.write_stylesheet read_dir, static_dir
  end


  def test_process_file
    write_dir = @params[:write_to_dir_for_indexing]
    delete_files_in_dir write_dir
    converter = Website::MarkdownConverter.new @params
    converter.process_file  "java.mmd", @params[:read_from_dir], write_dir
  end

  def delete_files_in_dir(dir)
    Dir["#{dir}/*"].each do |file|
      next if File.basename(file) == File.basename(dir)
      FileUtils.rm_f file, :noop => false, :verbose => true
    end
  end

  def test_get_process_files_list
    converter = Website::MarkdownConverter.new @params
    files_to_process, all_files = converter.get_files_to_process @params[:read_from_dir]
    p "Files to process: " if @debug
    p files_to_process if @debug
  end

  def publish_locally
    solr_indexer = "http://127.0.0.1:8983/solr/"
    converter = Website::MarkdownConverter.new :indexer_url => solr_indexer
    converter.go
  end

  def publish ops
    command = "rsync -avP --stats #{ops[:from_dir]} #{ops[:to_host]}:#{ops[:to_dir]}"
    p "[command]: " + command
    system command
  end

  def publish_remote
    home_dir = ENV['HOME']
    vpnTools = NetworkTools::VpnTools.new
    if vpnTools.on_vpn
      ops = {
        :to_host => 'l1',
        :from_dir => home_dir + '/bin/work-doco/',
        :to_dir => '/home/fenton/work-doco/' }
      publish ops
      ops[:to_dir] = '/home/fenton/website/'
    else
      ops = {
        :to_dir => '/home/ftravers/spicevan.com/current/public/',
        :to_host => 'dh' }
    end
    ops[:from_dir] = home_dir + '/bin/website/'
    publish ops
  end
  def pub_all
    publish_locally
    publish_remote
  end
end

pub = Publisher.new
#pub.publish_locally
#pub.test_get_process_files_list
#pub.test_process_file
#pub.test_process_files
pub.test_go
