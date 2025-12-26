# frozen_string_literal: true

require 'forwardable'
require 'fileutils'

module Gitlab
  module QA
    module Runtime
      class Logger
        extend SingleForwardable

        def_delegators :logger, :debug, :info, :warn, :error, :fatal, :unknown

        def self.logger
          @logger ||= begin
            log_path = Env.log_path
            ::FileUtils.mkdir_p(log_path)

            TestLogger.logger(level: Env.log_level, path: log_path)
          end
        end
      end
    end
  end
end
