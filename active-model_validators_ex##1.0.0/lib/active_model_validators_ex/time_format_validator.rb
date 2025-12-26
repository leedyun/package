class TimeFormatValidator < ActiveModel::EachValidator
  def initialize(options)
    unless options[:after].is_a?(NilClass) or
           options[:after].is_a?(Proc)     or
           options[:after].is_a?(Time)
      raise ArgumentError,
            'value after must be either NilClass, Proc or Time'
    end

    options[:allow_nil] ||= false

    super(options)
  end

  def validate_each(record, attribute, value)
    return if options[:allow_nil] && value.nil?

    parsed_time = value.is_a?(Time) ? value : Time.parse(value.to_s)

    previous_time = calculate_previous_time(record)

    if !previous_time.nil? and parsed_time < previous_time
      options[:value]         = value
      options[:previous_time] = previous_time

      record.errors.add(attribute, :time_greater_than, options)
    end
  rescue StandardError => e
    record.errors.add(attribute, :time_invalid, options)
  end

  def calculate_previous_time(record)
    case options[:after].class.name
    when 'Proc'
      options[:after].call(record)
    when 'Time'
      options[:after]
    end
  end
end