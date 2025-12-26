module Any
  module Validate
    module Macaddress

      def valid_macaddress? mac: nil
        return true if mac =~ /^[a-f\d]{1,2}:([a-f\d]{1,2}:){4}[a-f\d]{1,2}$/i
        return false
      rescue
        return false
      end

    end
  end
end
