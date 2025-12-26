require 'fluent/plugin/output'

module Fluent
  module Plugin
    class DatadogStatsdOutput < Output
      Fluent::Plugin.register_output('datadog_statsd', self)

      config_param :host, :string, default: nil
      config_param :port, :integer, default: nil

      config_param :metric_type, :string
      config_param :tags, :array, default: []
      config_param :add_fluentd_worker_id_to_tags, :bool, default: false

      config_section :metric, param_name: :metric_config, required: false,
                              multi: false, final: true do
        config_param :name, :string
        config_param :value, default: nil
      end

      config_section :event, param_name: :event_config, required: false,
                             multi: false, final: true do
        config_param :title, :string
        config_param :text, :string
        config_param :aggregation_key, :string, default: nil
        config_param :alert_type, :string, default: nil
        config_param :date_happened, default: nil
        config_param :priority, :string, default: nil
        config_param :source_type_name, :string, default: nil
      end

      config_section :buffer do
        config_set_default :flush_mode, :immediate
      end

      attr_reader :statsd

      def configure(conf)
        super

        placeholder_params = [
          @metric_type,
          @tags
        ]

        if @metric_config
          placeholder_params += [
            @metric_config.name,
            @metric_config.value
          ]
        end
        if @event_config
          placeholder_params += [
            @event_config.title,
            @event_config.text,
            @event_config.aggregation_key,
            @event_config.alert_type,
            @event_config.priority,
            @event_config.source_type_name,
            @event_config.date_happened
          ]
        end

        placeholder_validate!(:placeholder_params, placeholder_params.join('/'))

        require 'datadog/statsd'
        @host ||= Datadog::Statsd::DEFAULT_HOST
        @port ||= Datadog::Statsd::DEFAULT_PORT

        @statsd = Datadog::Statsd.new(@host, @port)
      end

      def start
        super
      end

      def shutdown
        super
        @statsd.close
      end

      def write(chunk)
        metadata = chunk.metadata
        metric_type = extract_placeholders(@metric_type, metadata).to_sym

        @statsd.batch do |statsd|
          statsd_param = case metric_type
                         when :increment, :decrement
                           if @metric_config.nil?
                             log.error("metric section is required when metric_type=#{metric_type}")
                             return nil
                           end
                           extract_placeholders_name_opt(metadata)

                         when :count, :gauge, :histgram, :timing, :set
                           if @metric_config.nil?
                             log.error("metric section is required when metric_type=#{metric_type}")
                             return nil
                           end
                           extract_placeholders_name_value_opt(metadata)
                         when :event
                           if @event_config.nil?
                             log.error('event section is required when metric_type=event')
                             return nil
                           end
                           extract_placeholders_event(metadata)
                         else
                           log.error("param 'metric_type=#{metric_type}' is illegal.")
                           return nil
                         end
          statsd_func = statsd.method(metric_type)
          chunk.each do |_time, _record|
            statsd_func.call(*statsd_param)
          end
        end
      end

      def multi_workers_ready?
        true
      end

      private

      def tags(metadata)
        tags = []
        tags << "fluentd_worker_id:#{fluentd_worker_id}" if @add_fluentd_worker_id_to_tags
        tags += @tags.map { |tag| extract_placeholders(tag, metadata) } if @tags
        tags
      end

      def extract_placeholders_name_opt(metadata)
        metric_name = extract_placeholders(@metric_config.name, metadata)
        options = {}
        options[:tags] = tags(metadata)

        [metric_name, options]
      end

      def extract_placeholders_name_value_opt(metadata)
        metric_name, options = extract_placeholders_name_opt(metadata)
        value = extract_placeholders(@metric_config.value, metadata)

        [metric_name, value, options]
      end

      def extract_placeholders_event(metadata)
        event_title = extract_placeholders(@event_config.title, metadata)
        event_text = extract_placeholders(@event_config.text, metadata)

        options = {}
        options[:tags] = tags(metadata)

        %i[aggregation_key alert_type date_happened priority source_type_name].each do |key|
          options[key] = extract_placeholders(@event_config[key], metadata) if @event_config[key]
        end

        options[:date_happened] = options[:date_happened].to_i if options[:date_happened]

        [event_title, event_text, options]
      end
    end
  end
end
