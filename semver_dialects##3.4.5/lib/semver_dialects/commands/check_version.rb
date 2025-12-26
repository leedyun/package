# frozen_string_literal: true

require_relative '../command'
require_relative '../../semver_dialects'

module SemverDialects
  module Commands
    # The check version command implementation
    class CheckVersion < SemverDialects::Command
      def initialize(type, version, constraint, options) # rubocop:todo Lint/MissingSuper
        @type = type
        @version = version
        @constraint = constraint
        @options = options
        @avail_types = %w[gem npm ruby pypi php maven go]
      end

      def execute(_input: $stdin, output: $stdout)
        typ = @type.downcase
        raise SemverDialects::Error, 'wrong package type' unless @avail_types.include?(typ)

        if SemverDialects.version_satisfies?(typ, @version, @constraint)
          output.puts "#{@version} matches #{@constraint} for #{@type}"
          0
        else
          output.puts "#{@version} does not match #{@constraint}"
          1
        end
      end
    end
  end
end
