module Cnvrg
  class LibraryCli < SubCommandBase
    map push: :import
    desc "library push", 'Push a new library to AI Library'
    def import
      unless File.exists? "library.yml"
        Cnvrg::CLI.log_message("Can't find library.yml", 'red')
        exit(1)
      end
      library = YAML.safe_load(File.open("library.yml").read)
      Cnvrg::CLI.log_message("Archiving library #{library["title"]}")
      files = Dir["**/*"].select{|file| not File.directory?(file)}
      File.open("archive.tar.gz", "wb") do |file|
        Zlib::GzipWriter.wrap(file) do |gzip|
          Gem::Package::TarWriter.new(gzip) do |tar|
            files.each do |filename|
              f = File.open(filename)
              tar.add_file_simple(filename, 0644, f.size) do |io|
                io.write(f.read)
              end
            end
          end
        end
      end
      response = Cnvrg::API.request(['users', Cnvrg::CLI.get_owner, 'libraries'].join("/"), "POST_FILE", {relative_path: "archive.tar.gz"})
      if response["status"] != 200
        Cnvrg::CLI.log_message("Can't create library: #{response["message"]}")
        exit(1)
      end
      Cnvrg::CLI.log_message("Library Created successfuly", "green")
    end
  end
end