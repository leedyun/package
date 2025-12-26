require "ackintosh/net/empty_port/version"
require "socket"

module Ackintosh
  module Net
    module EmptyPort

      # Find a free TCP/UDP port.
      # @param  protocol  [String]  tcp or udp
      # @return port      [Fixnum]
      def self.find(protocol = "tcp")
        port = 49152
        begin
          return port unless self.used?(port, protocol)
          port += 1
        end while port <= 65535

        raise "Empty port not found."
      end

      # Is the port used ?
      # @param  port[Fixnum]
      # @param  protocol[String]
      # @return [boolean]
      def self.used?(port, protocol = "tcp")
        class_name = (protocol == "tcp") ? "TCPSocket" : "UDPSocket"
        begin
          s = const_get(class_name).open("localhost", port)
        rescue => e
          return false
        end
        s.close
        true
      end
    end
  end
end
