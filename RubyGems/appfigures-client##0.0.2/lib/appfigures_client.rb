require 'appfigures_client/net/request'
require 'appfigures_client/api'
require 'appfigures_client/endpoints/endpoint'
require 'appfigures_client/endpoints/data'
require 'appfigures_client/endpoints/products'
require 'appfigures_client/endpoints/sales'
require 'appfigures_client/endpoints/ads'
require 'appfigures_client/endpoints/ranks'
require 'appfigures_client/endpoints/reviews'
require 'net/http'
require 'json'

module AppfiguresClient

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.init(username, password, client_key)

    Api.new({username: username, password: password, client_key: client_key})

  end

end