require 'bundler/setup'
require 'alidayu'

Bundler.setup

Alidayu.setup do |config|
  # config.server     = 'http://gw.api.taobao.com/router/rest'
  config.server     = 'https://eco.taobao.com/router/rest'
  config.app_key    = '12345'
  config.app_secret = '6789012345'
  config.sign_name  = '注册验证'
end