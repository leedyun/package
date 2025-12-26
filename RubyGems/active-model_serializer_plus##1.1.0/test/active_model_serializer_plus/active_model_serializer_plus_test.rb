require '../test_helper'
require 'active_model_serializer_plus'

class ActiveModelSerializerPlusTest < ActiveSupport::TestCase

    test 'API' do
        assert_not_nil ActiveModelSerializerPlus::VERSION
        assert_kind_of String, ActiveModelSerializerPlus::VERSION
    end
end
