require 'alerty'
require 'dogapi'
require 'dotenv'
Dotenv.load

class Alerty
  class Plugin
    class DatadogEvent
      def initialize(config)
        @client = Dogapi::Client.new(config.api_key)
        @subject = config.subject
        @alert_type = config.alert_type
        @num_retries = config.num_retries || 3
      end

      def alert(record)
        message = record[:output]
        subject = expand_placeholder(@subject, record)
        timestamp = Time.now.to_i
        retries = 0
        begin
          @client.emit_event(Dogapi::Event.new(message, :msg_title => subject, :alert_type => @alert_type, :date_happened => timestamp), :host => record[:hostname])
          Alerty.logger.info "Sent #{{subject: subject, message: message, alert_type: @alert_type, date: timestamp, host: record[:hostname]}} to Datadog Event"
        rescue => e
          retries += 1
          sleep 1
          if retries <= @num_retries
            retry
          else
            raise e
          end
        end
      end

      private

      def expand_placeholder(str, record)
        str.gsub('${command}', record[:command]).gsub('${hostname}', record[:hostname])
      end

    end
  end
end
