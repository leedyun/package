class Log
  class << self
    def logger
      @logger ||= ::Logging.logger(STDOUT)
      @logger.level = ENV.fetch("LOG_LEVEL", "warn").to_sym
      @logger
    end
    def warn(m); logger.warn(m); end
    def info(m); logger.info(m); end
    def debug(m); logger.debug(m); end
    def level=(l); logger.level = l; end
  end
end
