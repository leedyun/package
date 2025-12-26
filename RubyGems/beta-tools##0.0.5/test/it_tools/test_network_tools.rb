require "test/unit"

require_relative "../../lib/it_tools/network_tools"

module TestNetworkTools
  class TestVpnTools < Test::Unit::TestCase

    def test_login_to_url
      net = NetworkTools::VpnTools.new
      net.login_to_url
    end

  end
end
