module EbayTrading
  module Requests
    class Base      
      include EbayTrading::Types
      attr_accessor :auth_token, :username, :password

      def call_name
        self.class.to_s.split('::').last.gsub(/Request$/, '')
      end
    end
  end
end