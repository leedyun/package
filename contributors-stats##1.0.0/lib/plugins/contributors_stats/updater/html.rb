module ContributorsStats::Updater

  # Update a target file with content
  class Html
    # Default search pattern
    DEFAULT_SEARCH = /<span class="contributors">.*?<\/span>/m
    # Default replace template
    DEFAULT_REPLACE = %q{%Q{<span class="contributors">\n#{replace_content.join("\n")}\n</span>}}

    attr_accessor :search, :replace
    attr_reader   :file_content, :replace_content

    # check if given file is supported by this updater
    def self.handles?(file)
      %w{ .html .html.erb }.any?{|ext| file.end_with?(ext) }
    end

    # perform the content update
    def self.update(file_content, replace_content, options = {})
      new(file_content, replace_content, options).to_s
    end

    # set initial parameters, set default options
    def initialize(file_content, replace_content, options = {})
      @search  = options[:search]  || DEFAULT_SEARCH
      @replace = options[:replace] || DEFAULT_REPLACE
      @file_content    = file_content
      @replace_content = replace_content
    end

    # perform the replace operation
    def to_s
      file_content.sub( search, eval(replace) )
    end
  end
end
