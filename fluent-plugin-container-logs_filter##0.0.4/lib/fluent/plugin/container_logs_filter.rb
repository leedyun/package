require "json"
require 'fluentd'

module Fluent
  module Plugin
    class ContainerLogsFilter < Fluent::Filter
      
      Fluent::Plugin.register_filter('container_logs', self)


      def configure(conf)
        super
      end

      def filter(tag, time, record)
        record
      end

      def filter_stream(tag, es)
        new_es = MultiEventStream.new
        es.each { |time, record|
          begin
            transformed_record = remove_top_level_key(record)
            filtered_record = filter(tag, time, transformed_record)
            new_es.add(time, filtered_record) if filtered_record
          rescue  = > e
            router.emit_error_event(tag, time, record, e)
          end
        }
        new_es
      end

      def remove_top_level_key(record)
        nested_data = record[:log]
        JSON.parse nested_data
      end
    end
  end
end
