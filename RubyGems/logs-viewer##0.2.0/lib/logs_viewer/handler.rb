module LogsViewer
  class Handler

    def self.list(dir, type: nil )
      case type
        when :file then Dir[File.join(dir, '**')].reject {|f| File.directory?(f)}
        when :directory then Dir[File.join(dir, '**')].select {|f| File.directory?(f)}
        else Dir[File.join(dir, '**')]
      end
    end

    def self.file_open(path)
      File.open(File.expand_path(path,__FILE__),"r").read
    end

    def self.is_file?(path)
      File.file? path
    end

    def self.is_directory?(path)
      File.directory? path
    end

  end
end
