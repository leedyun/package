class ArrayValidatorBase < ActiveModel::EachValidator
  def initialize(options)
    options[:allow_nil]   ||= false
    options[:allow_blank] ||= false

    super(options)
  end

  def validate_each(record, attribute, value)
    # TODO: extract this to a more generic class instad of ArrayValidatorBase
    return if (options[:allow_blank] && value.blank?) ||
              (options[:allow_nil] && value.nil?)

    if !options[:allow_blank] && value.blank?
      record.errors.add(attribute, :blank, options)
      return
    end

    if !options[:allow_nil] && value.nil?
      record.errors.add(attribute, :nil, options)
      return
    end

    unless value.is_a? Array
      record.errors.add(attribute, :array, options)
      return
    end

    custom_validations(record, attribute, value)
  end

  def custom_validations(record, attribute, value)
    raise 'override this method to perform custom validations'
  end
end