module Alidayu
  class Configuration
    # API请求地址分为正式（http/https）和沙箱（http/https）共四个地址
    # 正式-http: http://gw.api.taobao.com/router/rest  
    # 正式-https: https://eco.taobao.com/router/rest
    # 沙箱-http: http://gw.api.tbsandbox.com/router/rest
    # 沙箱-https: https://gw.api.tbsandbox.com/router/rest
    def server
      @server ||= 'https://eco.taobao.com/router/rest'
    end

    def server=(server)
      @server = server
    end

    def app_key
      @app_key ||= 'your_app_key'
    end

    def app_key=(app_key)
      @app_key = app_key
    end

    def app_secret
      @app_secret ||= 'your_app_secret'
    end

    def app_secret=(app_secret)
      @app_secret = app_secret
    end

    def sign_name
      @sign_name ||= 'sign_name'
    end

    def sign_name=(sign_name)
      @sign_name = sign_name
    end
  end
end