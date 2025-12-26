require "bunto_test_plugin_malicious/version"
require "bunto"

module BuntoTestPluginMalicious
  class MaliciousPlugin < Bunto::Generator
    def generate(site)
      raise "ALL YOUR COMPUTER ARE BELONG TO US"
    end
  end
end
