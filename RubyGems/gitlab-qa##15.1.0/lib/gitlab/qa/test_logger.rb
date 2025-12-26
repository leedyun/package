# frozen_string_literal: true

require 'rainbow'
require 'active_support/logger'

module Gitlab
  module QA
    # Common test logger implementation
    #
    class TestLogger
      TIME_FORMAT = "%Y-%m-%d %H:%M:%S"
      LEVEL_COLORS = {
        "DEBUG" => :magenta,
        "INFO" => :green,
        "WARN" => :yellow,
        "ERROR" => :red,
        "FATAL" => :indianred
      }.freeze

      Rainbow.enabled = Runtime::Env.colorized_logs?

      class << self
        # Combined logger instance
        #
        # @param [<Symbol, String>] level
        # @param [String] source
        # @return [ActiveSupport::Logger, ActiveSupport::BroadcastLogger]
        def logger(level: :info, source: 'Gitlab QA', path: 'tmp')
          console_log = console_logger(level: level, source: source)
          file_log = file_logger(source: source, path: path)

          if ActiveSupport.const_defined?(:BroadcastLogger)
            ActiveSupport::BroadcastLogger.new(console_log, file_log)
          elsif ActiveSupport::Logger.respond_to?(:broadcast)
            console_log.extend(ActiveSupport::Logger.broadcast(file_log))
          else
            raise 'Could not configure logger broadcasting'
          end
        end

        private

        # Console logger instance
        #
        # @param [<Symbol, String>] level
        # @param [String] source
        # @return [ActiveSupport::Logger]
        def console_logger(level:, source:)
          ActiveSupport::Logger.new($stdout, level: level, datetime_format: TIME_FORMAT).tap do |logger|
            logger.formatter = proc do |severity, datetime, _progname, msg|
              msg_prefix = message_prefix(datetime, source, severity)

              Rainbow(msg_prefix).public_send(LEVEL_COLORS.fetch(severity, :silver)) + "#{msg}\n" # rubocop:disable GitlabSecurity/PublicSend
            end
          end
        end

        # File logger
        #
        # @param [String] source
        # @param [String] path
        # @return [ActiveSupport::Logger]
        def file_logger(source:, path:)
          log_file = "#{path}/#{source.downcase.tr(' ', '-')}.log"

          ActiveSupport::Logger.new(log_file, level: :debug, datetime_format: TIME_FORMAT).tap do |logger|
            logger.formatter = proc do |severity, datetime, _progname, msg|
              msg_prefix = message_prefix(datetime, source, severity)

              "#{msg_prefix}#{msg}\n".gsub(/\e\[(\d+)(?:;\d+)*m/, "")
            end
          end
        end

        # Log message prefix
        #
        # @note when outputted, the date will be formatted as "Jun 07 2022 11:30:00 UTC"
        # @param [DateTime] date
        # @param [String] source
        # @param [String] severity
        # @return [String]
        def message_prefix(date, source, severity)
          "[#{date.strftime('%h %d %Y %H:%M:%S %Z')} (#{source})] #{severity.ljust(5)} -- "
        end
      end
    end
  end
end
