module ContributorsStats

  # Basis for ContributorsStats, includes logging and plugins support
  class Base
    attr_accessor :logger, :options

    def initialize(options = {})
      @logger = $stdout
      @logger = options.delete(:logger) if options[:logger]
      @options = options
    end

  private

    def filter_options(type)
      @options.select do |key, value|
        plugins.class_exist?(type, key)
      end
    end

    def plugins
      @plugins ||= Pluginator.find("contributors_stats", extends: %i{first_class class_exist})
    end

    def log(text)
      logger.respond_to?(:info) ? logger.info(text) : logger.puts(text)
    end
  end
end
