require '../test_helper'
require 'active_model_type_validator'

class ActiveModelTypeValidatorTest < ActiveSupport::TestCase

    test 'API' do
        assert_not_nil ActiveModelTypeValidator::VERSION
        assert_kind_of String, ActiveModelTypeValidator::VERSION
    end

end
