module Any
  module Validate
    module Ipaddress

      def valid_ipaddress? ip: nil
        return true if ip =~ /^(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])$/
        return false
      rescue
        return false
      end

    end
  end
end
