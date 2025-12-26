require_relative "base"

class ABBYY::Cloud
  module Operations
    class Engines < Base
      # rubocop: disable Metrics/LineLength
      link "https://api.abbyy.cloud/swagger/ui/index#!/MachineTranslation/MachineTranslation_Engines"
      # rubocop: enable Metrics/LineLength
      path { "v0/mt/engines" }
      http_method "get"

      response_body Types::Array.member(Types::Engine)
    end
  end
end
