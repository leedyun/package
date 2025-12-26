class ImmutableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    return if record.new_record?
    return unless record.public_send("#{attribute}_changed?")
    record.errors.add(attribute, options[:message] || :immutable)
  end
end
