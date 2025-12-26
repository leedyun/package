# frozen_string_literal: true

require 'open3'
require 'active_support'
require 'active_support/core_ext/string/filters'

module Gitlab
  module QA
    module Support
      class ShellCommand
        using Rainbow

        StatusError = Class.new(StandardError)

        # Shell command
        #
        # @param [<String, Array>] command
        # @param [<String, Array>] mask_secrets
        # @param [Boolean] stream_output stream command output to stdout directly instead of logger
        def initialize(command = nil, stdin_data: nil, mask_secrets: nil, stream_output: false)
          @command = command
          @mask_secrets = Array(mask_secrets)
          @stream_output = stream_output
          @output = []
          @logger = Runtime::Logger.logger
          @stdin_data = stdin_data
        end

        attr_reader :command, :output, :stream_output

        def execute! # rubocop:disable Metrics/AbcSize
          raise StatusError, 'Command already executed' if output.any?

          logger.info("Shell command: `#{mask_secrets(command).cyan}`")

          Open3.popen2e(command.to_s) do |stdin, out, wait|
            if @stdin_data
              stdin.puts(@stdin_data)
              stdin.close
            end

            out.each do |line|
              output.push(line)

              if stream_progress
                print "."
              elsif stream_output
                puts line
              end

              yield line, wait if block_given?
            end
            puts if stream_progress && !output.empty?

            fail! if wait.value.exited? && wait.value.exitstatus.nonzero?

            logger.debug("Shell command output:\n#{string_output}") unless stream_output || output.empty?
          end

          string_output
        end

        private

        attr_reader :logger

        # Raise error and print output to error log level
        #
        # @return [void]
        def fail!
          logger.error("Shell command output:\n#{string_output}") unless @command.include?("docker attach") || stream_output
          raise StatusError, "Command `#{mask_secrets(command).truncate(100)}` failed! " + "✘".red
        end

        # Stream only command execution progress and log output when command finished
        #
        # @return [Boolean]
        def stream_progress
          !(Runtime::Env.ci || stream_output)
        end

        # Stringified command output
        #
        # @return [String]
        def string_output
          mask_secrets(output.join.chomp)
        end

        # Returns a masked string
        #
        # @param [String] input the string to mask
        # @return [String] The masked string
        def mask_secrets(input)
          @mask_secrets.reduce(input) { |s, secret| s.gsub(secret, '*****') }.to_s
        end
      end
    end
  end
end
