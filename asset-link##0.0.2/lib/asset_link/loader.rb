require 'open-uri'

module AssetLink
  class Loader

    def upload(files)
      files.each do |f|
        next unless File.file?(f)
        puts "Uploading: #{f}"
        link = upload_file(f)
        create_link_file(f, link)
        File.delete(f)
      end
    end

    def download(files)
      files.each do |f|
        next if !File.file?(f) || File.extname(f) != '.link'
        puts "Downloading: #{f}"
        link = read_file(f)
        download_file(f, link)
        File.delete(f)
      end
    end

    private

    def read_file(f)
      File.read(f).strip
    end

    def upload_file(f)
      ext = File.extname(f)[1..-1]
      mime = MultiMime.lookup(ext)
      file = {
          :key => f,
          :body => File.open(f),
          :public => true,
          :content_type => mime
      }

      storage.bucket.files.create(file).public_url
    end

    def download_file(f, link)
      new_filename = f.gsub('.link', '')
      open(new_filename, 'w') do |file|
        file << open(link).read
      end
    end

    def create_link_file(f, link)
      File.open("#{f}.link", "w") do |file|
        file.write(link)
      end
    end

    def config
      @config ||= AssetLink::Config.new
    end

    def storage
      @storage ||= AssetLink::Storage.new(config)
    end

  end
end
