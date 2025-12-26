# frozen_string_literal: true

module OmniAuth
  module Strategies
    class OneTest
      include OmniAuth::Strategy
      include OmniAuth::MultiPassword::Base

      def authenticate(username, password)
        username == 'john' && password == 'secret'
      end
    end
  end
end

module OmniAuth
  module Strategies
    class TwoTest
      include OmniAuth::Strategy
      include OmniAuth::MultiPassword::Base

      def authenticate(username, password)
        username == 'jane' && password == '1234'
      end
    end
  end
end
