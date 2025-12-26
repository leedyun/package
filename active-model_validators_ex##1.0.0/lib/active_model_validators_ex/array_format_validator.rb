require 'active_model_validators_ex/array_validator_base'

class ArrayFormatValidator < ArrayValidatorBase
  def initialize(options)
    unless options.key?(:with) and options[:with].is_a?(Regexp)
      raise 'options must contain a key :with, where the value is a Regexp'
    end

    super(options)
  end

  def custom_validations(record, attribute, value)
    unless value.all? { |val| !val.match(options[:with]).nil? }
      record.errors.add(attribute, :array_format, options)
    end
  end
end