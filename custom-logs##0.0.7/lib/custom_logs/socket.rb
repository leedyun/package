require 'remote_syslog_logger'

module CustomLogs
  class Socket

    @@socket = nil
    @@socket_type = nil

    class << self
      def get
        @@socket if @@socket
        if (syslog_config = ParseConfig.get[:syslog]).present?
          @@socket = RemoteSyslogLogger.new(syslog_config[:host], syslog_config[:port])
          @@socket_type = :syslog
        else
          @@socket = ::Logger.new(STDOUT)
          @@socket_type = :stdout
        end

        @@socket.formatter  = proc do |severity, datetime, progname, msg|
          "#{msg}\n"
        end

        @@socket
      end

      def write(message)
        get.unknown("[CUSTOM-LOGS]#{message}")
      end

      def socket_type
        get unless @@socket
        @@socket_type
      end

      def syslog?
        socket_type == :syslog
      end

      def stdout?
        socket_type == :stdout
      end

    end

  end
end