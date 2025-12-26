module ArchiveUploader
  class Archiver
    def initialize(options={})
      @files = options[:files] || []
      @archive_file = options[:name] || Tempfile.new(["archive_uploader", ".tgz"])
    end
    
    def perform!
      `tar -czf #{@archive_file.path} #{@files.join(" ")}`
      @archive_file
    end
  end
end