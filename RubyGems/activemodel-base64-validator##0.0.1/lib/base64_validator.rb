class Base64Validator < ActiveModel::EachValidator
  REGEXP = %r<\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?\z>

  def self.valid?(value)
    !!(value =~ REGEXP)
  end

  def validate_each(record, attribute, value)
    unless self.class.valid?(value)
      record.errors.add(attribute, options[:message] || :invalid_base64)
    end
  end
end
