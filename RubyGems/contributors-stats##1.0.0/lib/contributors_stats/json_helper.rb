require 'json'
require 'open-uri'

module ContributorsStats

  # Support code for loading json urls/files
  module JsonHelper

    # Build full path to resource to use
    def url_builder(path)
      "#{self.path_prefix}#{path}#{self.path_suffix}"
    end

    # Load json from url, fallback to prefix
    def load_json(url)
      open(url){ |json| JSON.load(json) }
    rescue Exception => e
      if File.exist?("#{self.path_prefix}#{url}")
        open("#{self.path_prefix}#{url}"){ |json| JSON.load(json) }
      elsif File.exist?("#{self.path_prefix}#{url}#{self.path_suffix}")
        open("#{self.path_prefix}#{url}#{self.path_suffix}"){ |json| JSON.load(json) }
      else
        raise e
      end
    end

    # get prefix, sets the default if empty, makes sure it's ending with '/'
    def path_prefix
      @path_prefix ||= "https://api.github.com"
      @path_prefix+="/" if @path_prefix != "" && @path_prefix[-1] != "/"
      @path_prefix
    end

    # get suffix, sets the default if empty, makes sure it's starts with '.'
    def path_suffix
      @path_suffix ||= ""
      @path_suffix = ".#{@path_suffix}" if @path_suffix != "" && @path_suffix[0] != "."
      @path_suffix
    end

  protected

    def configure_path(prefix, suffix)
      @path_prefix = prefix
      @path_suffix = suffix
    end

  end
end
