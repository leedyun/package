require 'active_model/validations'

module ActiveModel
  module Validations
    class AtLeastOneExistenceValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add attribute, :at_least_one if value.all? { |item| item.marked_for_destruction? }
      end
    end

    module HelperMethods
      def validates_at_least_one_existence_of(*attr_names)
        validates_with AtLeastOneExistenceValidator, _merge_attributes(attr_names)
      end
    end
  end
end
