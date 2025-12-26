require 'datadog_apm/version'
require 'gem_config'
require 'statsd'

module DatadogApm
  include GemConfig::Base

  with_configuration do
    has :environments, classes: Array, default: ['production']
    has :tags, classes: Array, default: []
    has :metric, classes: [Symbol, String], default: 'apm'
    has :slow_query_max_duration, classes: [Float], default: 2.0
  end

  class Railtie < Rails::Railtie
    initializer "datadoge.configure_rails_initialization" do |app|
      $statsd = Statsd.new

      ActiveSupport::Notifications.subscribe /process_action.action_controller/ do |*args|
        event = ActiveSupport::Notifications::Event.new(*args)
        controller = "controller:#{event.payload[:controller]}"
        action = "action:#{event.payload[:action]}"
        controller_action = "controller_action:#{event.payload[:controller]}##{event.payload[:action]}"
        format = "format:#{event.payload[:format] || 'all'}"
        format = "format:all" if format == "format:*/*"
        status = event.payload[:status]
        #Rails.logger.error "payload@@: #{event.inspect}"
        tags = DatadogApm.configuration.tags + [controller, action, controller_action, format, "request.status.#{status}", "request.method.#{event.payload[:method]}"]
        ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "request.total_duration", :value => event.duration
        ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "database.query.time", :value => event.payload[:db_runtime]
        ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "web.view.time", :value => event.payload[:view_runtime]
        ActiveSupport::Notifications.instrument :performance, :action => :timing, :tags => tags, :measurement => "elasticsearch.query.time", :value => event.payload[:elasticsearch_runtime]
        ActiveSupport::Notifications.instrument :performance, :tags => tags,  :measurement => "request.status.#{status}"
        ActiveSupport::Notifications.instrument :performance, :tags => tags,  :measurement => "request.method.#{event.payload[:method]}"
      end

      ActiveSupport::Notifications.subscribe('sql.active_record') do |name, start, finish, id, payload|
        duration = finish.to_f - start.to_f
        if duration >= DatadogApm.configuration.slow_query_max_duration.to_f
          if !payload[:sql].starts_with?("EXPLAIN", "SHOW")
            ActiveRecord::Base.connection.execute("EXPLAIN #{payload[:sql]}").each(:as => :hash) do |row|
              #{"id"=>1, "select_type"=>"SIMPLE", "table"=>"currencies", "partitions"=>nil, "type"=>"const", "possible_keys"=>"PRIMARY", "key"=>"PRIMARY", "key_len"=>"4", "ref"=>"const", "rows"=>1, "filtered"=>100.0, "Extra"=>nil}
              message = {
                sql: payload[:sql].gsub("\n", ""),
                select_type: row["select_type"],
                table: row["table"],
                possible_keys: row["possible_keys"],
                key: row["key"],
                key_len: row["key_len"],
                rows: row["rows"],
                filtered: row["filtered"]
              }.map{ |k, v| "#{k} = #{v}" }.join('\n')
              $statsd.event("SQL Slow Query: #{duration} >= #{DatadogApm.configuration.slow_query_max_duration.to_f}", message, :tags => DatadogApm.configuration.tags) unless $statsd.nil?
            end
          end
        end
      end

      ActiveSupport::Notifications.subscribe /performance/ do |name, start, finish, id, payload|
        send_event_to_statsd(name, payload) if DatadogApm.configuration.environments.include?(Rails.env)
      end

      def send_event_to_statsd(name, payload)
        action = payload[:action] || :increment
        measurement = payload[:measurement]
        value = payload[:value]
        tags = payload[:tags]
        key_name = "#{DatadogApm.configuration.metric.to_s}.#{measurement}"
        if action == :increment
          $statsd.increment key_name, :tags => tags unless $statsd.nil?
        else
          $statsd.histogram key_name, value, :tags => tags unless $statsd.nil?
        end
      end

    end
  end
end
