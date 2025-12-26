# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestMetric
      class JsonTestMetric
        attr_reader :metric

        def initialize(metric)
          @metric = metric
        end

        def name
          metric.fetch('name')
        end

        def time
          metric.fetch('time')
        end

        def tags
          @tags ||= metric.fetch('tags')
        end

        def fields
          @fields ||= metric.fetch('fields')
        end

        def to_json(*options)
          as_json.to_json(*options)
        end

        private

        def as_json
          {
            name: name,
            time: time,
            tags: tags,
            fields: fields
          }
        end
      end
    end
  end
end
