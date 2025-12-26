require 'rspec'
require 'rspec/core/formatters/json_formatter'
require 'rspec/core/formatters/base_formatter'
require 'json'

module RSpec
  module Core
    module Formatters
      class AssemblylineFormatter < JsonFormatter
        def stop
          super
          @output_hash[:examples] = examples.map do |example|
            {
              :description => example.description,
              :full_description => example.full_description,
              :status => example.execution_result[:status],
              # :example_group,
              # :execution_result,
              :file_path => example.metadata[:file_path],
              :line_number  => example.metadata[:line_number],
              :run_time => example.execution_result[:run_time],
            }.tap do |hash|
              if e=example.exception
                hash[:exception] =  {
                  :class => e.class.name,
                  :message => e.message,
                  :backtrace => e.backtrace,
                }
              end
            end
          end
        end
      end
    end
  end
end

AssemblylineFormatter = RSpec::Core::Formatters::AssemblylineFormatter
