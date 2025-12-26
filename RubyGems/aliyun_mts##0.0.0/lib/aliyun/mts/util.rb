# -*- encoding: utf-8 -*-

require 'time'
require 'base64'
require 'cgi'
require 'openssl'
require 'digest/md5'

module Aliyun
  module MTS
    module Util
      class << self

        # 签名后参数
        def signature_params(params)
          params.merge!(default_params)
          params[:Signature] = get_signature(params)
          params
        end

        def get_signature(params)
          cano_query = params.sort.map {
            |k, v| [CGI.escape(k.to_s), CGI.escape(v)].join('=') }.join('&')

          string_to_sign =
            'GET&' + CGI.escape('/') + '&' + CGI.escape(cano_query)

          Base64.strict_encode64(
            OpenSSL::HMAC.digest('sha1', Aliyun::MTS.access_key_secret + "&", string_to_sign))
        end

        def default_params
          {
            Format:           "JSON",
            Version:          "2014-06-18",
            AccessKeyId:      Aliyun::MTS.access_key_id,
            SignatureMethod:  "HMAC-SHA1",
            Timestamp:        Time.now.utc.iso8601,
            SignatureVersion: "1.0",
            SignatureNonce:   signature_nonce
          }
        end

        private 
          def signature_nonce
            (rand * 1_000_000_000).to_s
          end
      end
    end
  end
end