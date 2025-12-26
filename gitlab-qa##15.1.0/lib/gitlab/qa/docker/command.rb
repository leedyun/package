# frozen_string_literal: true

module Gitlab
  module QA
    module Docker
      class Command
        attr_reader :args

        # Shell command
        #
        # @param [<String, Array>] cmd
        # @param [<String, Array>] mask_secrets
        # @param [Boolean] stream_output stream command output to stdout directly instead of logger
        def initialize(cmd = nil, mask_secrets: nil, stream_output: false)
          @args = Array(cmd)
          @mask_secrets = mask_secrets
          @stream_output = stream_output
        end

        def <<(*args)
          tap { @args.concat(args) }
        end

        def volume(from, to, opt = :z)
          tap { @args.push("--volume #{from}:#{to}:#{opt}") }
        end

        def name(identity)
          tap { @args.push("--name #{identity}") }
        end

        def env(name, value)
          tap { @args.push(%(--env #{name}="#{value}")) }
        end

        def port(mapping)
          tap { @args.push("-p #{mapping}") }
        end

        def to_s
          "docker #{@args.join(' ')}"
        end

        def ==(other)
          to_s == other.to_s
        end

        def execute!(&block)
          Support::ShellCommand.new(to_s, mask_secrets: @mask_secrets, stream_output: @stream_output).execute!(&block)
        rescue Support::ShellCommand::StatusError => e
          e.set_backtrace([])

          raise e
        end

        def self.execute(cmd, mask_secrets: nil, &block)
          new(cmd, mask_secrets: mask_secrets).execute!(&block)
        end
      end
    end
  end
end
