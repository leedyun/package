# frozen_string_literal: true

require 'json'

module GitlabQuality
  module TestTooling
    module TestMetrics
      class JsonTestMetricCollection
        include Enumerable

        attr_reader :path, :metrics

        def initialize(path)
          @path = path
          @metrics = process
        end

        def metric_for_test_id(test_id)
          metrics.find do |metric|
            metric.fields['id'] == test_id
          end
        end

        def write
          File.write(path, JSON.pretty_generate(metrics))
        end

        private

        def parse
          JSON.parse(File.read(path))
        rescue JSON::ParserError
          Runtime::Logger.debug("#{self.class.name}##{__method__} attempted to parse invalid JSON at path: #{path}")
          {}
        end

        def process
          parse.map do |test|
            GitlabQuality::TestTooling::TestMetric::JsonTestMetric.new(test)
          end
        end
      end
    end
  end
end
