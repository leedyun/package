# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module LogTypes
        class Log
          def initialize(name, data)
            @name = name
            @data = data
          end

          attr_reader :name, :data

          def summary_fields
            [
              :severity,
              :correlation_id,
              :time,
              :message
            ]
          end

          def summary
            summary = {}

            summary_fields.each do |field|
              value = data[field]
              summary[field] = value unless value.nil?
            end

            summary
          end
        end
      end
    end
  end
end
