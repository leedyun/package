require "active_model"
require "active_model/attributes_validation/version"

module ActiveModel
  module AttributesValidation

    def attributes_valid?(*attrs)
      errors.clear

      attr_validators = self.class.validators_on(*attrs).uniq
      specific_validators = attr_validators.collect do |validator|
        validator = validator.dup
        validated_attributes = validator.attributes & attrs
        validator.instance_variable_set(:@attributes, validated_attributes)
        validator
      end

      self_validation = ->{ specific_validators.each { |validator| validator.validate(self) } }

      if self.class.ancestors.include?(ActiveModel::Validations::Callbacks)
        run_callbacks(:validation) { self_validation.call }
      else
        self_validation.call
      end

      errors.empty?
    end

  end
end

if defined? ActiveRecord
  module ActiveRecord
    class Base
      include ActiveModel::AttributesValidation
    end
  end
end
