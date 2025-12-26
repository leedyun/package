require 'curl'
require 'optparse'
require 'ostruct'
require 'tempfile'
require "archive_uploader/archiver"
require "archive_uploader/curb"
require "archive_uploader/git"
require "archive_uploader/version"
require "archive_uploader/cli"

module ArchiveUploader
  module_function
  def start(options)
    @options = options
    puts get_url
    puts "Start uploading files"
    @file = Archiver.new(:files => options.directories).perform!
    @git_data = Git.data
    # puts @git_data
    puts Curb.new(:file => @file.path, :fields => @git_data, :url => ENV["ARCHIVE_UPLOADER_URL"], :auth => options.auth).perform!
    
  ensure
    FileUtils.rm(@file)
  end


  def get_url
    ENV["ARCHIVE_UPLOADER_URL"] || @options.url 
  end
end
