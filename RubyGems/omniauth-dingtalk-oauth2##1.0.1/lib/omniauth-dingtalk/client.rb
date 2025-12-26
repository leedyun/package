# frozen_string_literal: true

require 'omniauth-dingtalk/client/third_party_personal'
require 'omniauth-dingtalk/client/enterprise_internal'

module OmniAuth
  module Dingtalk
    module Client
      def self.get(client_type)
        case client_type.to_s
        when 'third_party_personal'
          ::OmniAuth::Dingtalk::Client::ThirdPartyPersonal
        else
          ::OmniAuth::Dingtalk::Client::EnterpriseInternal
        end
      end
    end
  end
end
