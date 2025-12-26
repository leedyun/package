# frozen_string_literal: true

require 'influxdb-client'

module GitlabQuality
  module TestTooling
    module TestMetricsExporter
      module Support
        module InfluxdbTools
          # InfluxDb client
          #
          # @return [InfluxDB2::Client]
          def influx_client(url:, token:, bucket:)
            @influx_client ||= InfluxDB2::Client.new(
              url || raise('Missing influxdb_url'),
              token || raise('Missing influxdb_token'),
              bucket: bucket || raise('Missing influxdb_bucket'),
              org: "gitlab-qa",
              precision: InfluxDB2::WritePrecision::NANOSECOND
            )
          end

          # Write client
          #
          # @return [WriteApi]
          def write_api(url:, token:, bucket:)
            @write_api ||= influx_client(url: url, token: token, bucket: bucket).create_write_api
          end
        end
      end
    end
  end
end
