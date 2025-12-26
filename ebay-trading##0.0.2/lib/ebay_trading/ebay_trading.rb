class Hash
  def stringify_keys!
    keys.each do |key|
      unless key.class.to_s == "String" # weird hack to make the tests run when string_ext_test.rb is also running
        self[key.to_s] = self[key]
        delete(key)
      end
    end
    self
  end
end

require 'ebay_trading/initializer'
require 'ebay_trading/enumeration'
require 'ebay_trading/inflections'
require 'ebay_trading/schema/version'

# Fix circular dependency
module EbayTrading
  module Types
    class Transaction; end
    class Order; end
  end
end

if File.exists?(File.dirname(__FILE__) + '/requests.rb') && File.exists?(File.dirname(__FILE__) + '/responses.rb')
  require 'ebay_trading/types'
  require 'ebay_trading/request/base'
  require 'ebay_trading/response/base'
  require 'ebay_trading/requests'
  require 'ebay_trading/responses'
end

require 'ebay_trading/api'
require 'ebay_trading/notification'
