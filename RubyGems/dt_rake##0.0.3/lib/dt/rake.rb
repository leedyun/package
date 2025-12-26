require "dt/rake/version"
require "dt/rake_helper"
require "pathname"

module Dt
  module Rake
    
    SCRIPT_RAILS = 'script/rails'
    
    def self.get_rails_dir(dir)
      path = ::Pathname.new(dir)

      while path != path.parent
        return path if rails_dir?(path)
        path = path.parent
      end

      raise "No rails dir found in path"
    end

    def self.rails_dir?(dir)
      return File.exists? ("#{dir}/#{SCRIPT_RAILS}")
    end
  end
end
