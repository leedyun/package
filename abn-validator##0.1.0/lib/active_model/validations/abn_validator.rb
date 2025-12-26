require 'active_model'

module ActiveModel
  module Validations
    class AbnValidator < ActiveModel::EachValidator

      ABN_WEIGHTS = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

      def validate_each(record, attribute, value)

        return if value.nil? || value == ''

        abn = value.delete(' ').split('').map(&:to_i)

        if abn.length != 11
          record.errors.add attribute, :invalid_abn_length, value: value
          return
        end

        abn[0] = abn[0] - 1
        record.errors.add attribute, :invalid_abn, value: value unless abn.zip(ABN_WEIGHTS).map{|a,w|a*w}.inject(:+)/89.00 % 1 == 0

      end
    end


    module HelperMethods

      def validates_abn(*attr_names)
        validates_with AbnValidator, _merge_attributes(attr_names)
      end

    end
  end
end
