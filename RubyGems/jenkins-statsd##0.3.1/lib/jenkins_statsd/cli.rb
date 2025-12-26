require 'eventmachine'
require 'semantic_logger'
require 'thor'

require 'jenkins_statsd/jenkins_client'
require 'jenkins_statsd/statsd_client'

module JenkinsStatsd
  class CLI < Thor

    desc 'start [OPTIONS]', 'start the client'
    option :jenkins_host,
      aliases: '-j',
      type: :string,
      required: true,
      desc: 'The jenkins base url'
    option :jenkins_token,
      aliases: '-t',
      type: :string,
      required: true,
      desc: 'The jenkins metrics plugin api token'
    option :statsd_host,
      aliases: '-s',
      type: :string,
      required: true,
      desc: 'The statsd host'
    option :statsd_port,
      aliases: '-p',
      type: :numeric,
      required: true,
      desc: 'The statsd port'
    option :namespace,
      aliases: '-n',
      type: :string,
      required: true,
      desc: 'The metric namespace'
    option :interval,
      aliases: '-i',
      type: :numeric,
      default: 30.0,
      desc: 'The interval in seconds'
    option :log_level,
      aliases: '-l',
      type: :string,
      default: 'info',
      desc: 'The log level, one of trace, debug, info, warn, error, crit'
    def start
      SemanticLogger.default_level = options[:log_level].downcase.to_sym
      SemanticLogger.add_appender(io: $stdout, level: :trace, formatter: :color)
      logger = SemanticLogger['JenkinsStatsd']

      jenkins_client = JenkinsClient.new(options[:jenkins_host],
                                         options[:jenkins_token])

      stats_client = StatsdClient.new(options[:statsd_host],
                                      options[:statsd_port],
                                      options[:namespace])

      EventMachine.run do
        logger.info("Starting... first check in #{options[:interval]} seconds")

        EventMachine.add_periodic_timer(options[:interval]) do
          logger.debug('Fetching metrics')
          begin
            metrics = jenkins_client.get_metrics
            logger.trace(metrics)

            begin
              logger.debug('Sending metrics')
              stats_client.send_metrics(metrics)
            rescue Exception => e
              logger.error("Error sending metrics: #{e}")
            end
          rescue Exception => e
            logger.error("Error fetching metrics: #{e}")
          end
        end
      end
    end
  end
end
