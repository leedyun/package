# frozen_string_literal: true

require 'omniauth-dingtalk/client/base'

module OmniAuth
  module Dingtalk
    module Client
      class ThirdPartyPersonal < ::OmniAuth::Dingtalk::Client::Base
        TOKEN_URL = '/sns/gettoken'

        def get_user_info(params = {})
          resp = get_user_info_by_code(params[:code])
          resp['user_info'] || {}
        end
      end
    end
  end
end
