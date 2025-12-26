class CanValidator < ActiveModel::EachValidator
  RESERVED_OPTIONS = [:allow_nil, :allow_blank, :message, :on, :if, :unless]

  def validate_each(record, attribute, value)
    if !value.respond_to?(:can?) || !has_permission?(record, value)
      record.errors.add(attribute, options[:message] || :permission_denied)
    end
  end

  private

  def has_permission?(record, value)
    actions = options.keys - RESERVED_OPTIONS
    actions.all? do |action|
      options[action] ? value.can?(action, record) : value.cannot?(action, record)
    end
  end
end
