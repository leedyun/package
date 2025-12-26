class CountValidator < ActiveModel::Validations::LengthValidator
  MESSAGES = {
    :wrong_length => :count_invalid,
    :too_short => :count_greater_than_or_equal_to,
    :too_long => :count_less_than_or_equal_to
  }.freeze

  def initialize(options)
    options = options.reverse_merge(MESSAGES)
    super
  end

  def validate_each(record, attribute, value)
    existing_records = record.send(attribute).reject(&:marked_for_destruction?)
    super(record, attribute, existing_records)
  end
end
