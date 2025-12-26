require 'net/http'
require "json"

module Alidayu
  module Helper
    # 获得响应结果
    def get_response(params)
      uri = URI(Alidayu.config.server)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      request = Net::HTTP::Post.new(uri.path)
      request_params = build_params(params)
      request.add_field('Content-Type', 'application/json')
      request.set_form_data(request_params)
      response = http.request(request)
      Alidayu.logger.info response.body
      return JSON.parse(response.body)
    end

    private
    # 构建请求参数
    def build_params(params)
      params[:app_key] = params[:app_key] || Alidayu.config.app_key
      params[:timestamp] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      params[:format] = 'json'
      params[:v] = '2.0'
      params[:sign_method] = 'hmac'

      signature = generate_signature(params)

      params[:sign] = signature
      return params
    end

    # 生成签名 hmac
    def generate_signature(params)
      params.delete(:sign)
      data = params.sort.compact.join
      digest = OpenSSL::Digest.new('md5')
      secret = params[:app_secret] || Alidayu.config.app_secret
      hmac_sign = OpenSSL::HMAC.hexdigest(digest, secret, data).upcase
      return hmac_sign
    end
  end
end