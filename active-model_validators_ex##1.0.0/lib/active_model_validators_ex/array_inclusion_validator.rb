require 'active_model_validators_ex/array_validator_base'

class ArrayInclusionValidator < ArrayValidatorBase
  def initialize(options)
    unless options[:in].is_a?(Array) or options[:in].is_a?(Range)
      raise ArgumentError,
            'value for in must be either a Range or Array'
    end

    super(options)
  end

  def custom_validations(record, attribute, value)
    unless value.all? { |val| options[:in].include?(val) }
      record.errors.add(attribute, :array_inclusion, options)
    end
  end
end