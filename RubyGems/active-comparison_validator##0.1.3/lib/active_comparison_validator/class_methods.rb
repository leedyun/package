module ActiveComparisonValidator
  module ClassMethods
    # Verified: that A is greater than B.
    # @param [String] field_a_<_field_b This string is field_name, operator_name and field_name
    # @return Define a custom validator in the context of the model.
    # @example open_at < close_at
    #     class Shop < ActiveRecord::Base
    #       include OriginValidator
    #       comparison_validator 'open_at < close_at'
    #     end
    # @note
    #   You can use their operator.
    #     - '<'
    #     - '<='
    #     - '>'
    #     - '>='
    #     - '=='
    #     - '!='
    # @note
    #   And localization.
    #     - Dedault is used errors.messages
    #       - greater_than
    #       - less_than
    #       - greater_than_or_equal_to
    #       - less_than_or_equal_to
    #       - confirmation
    #       - other_than
    def comparison_validator(a_operator_b)
      a_attr, operator, b_attr = *a_operator_b.split(/\s/).map(&:to_sym)
      method_name = "comparison_validator_for_#{a_attr}_and_#{b_attr}"
      define_method(method_name) do
        a_value = send(a_attr)
        to_value = send(b_attr)
        return unless a_value && to_value
        locals = {
          :<  => [:greater_than,             :less_than,                :count],
          :<= => [:greater_than_or_equal_to, :less_than_or_equal_to,    :count],
          :>  => [:less_than,                :greater_than,             :count],
          :>= => [:less_than_or_equal_to,    :greater_than_or_equal_to, :count],
          :== => [:confirmation,             :confirmation,             :attribute],
          :!= => [:other_than,               :other_than,               :attribute]
        }
        return unless locals.key?(operator)
        return if a_value.send(operator, to_value)
        a_value_human = { locals[operator].last => self.class.human_attribute_name(a_attr) }
        b_value_human = { locals[operator].last => self.class.human_attribute_name(b_attr) }

        I18n.with_options scope: 'errors.messages' do |locale|
          errors.add(b_attr, locale.t(locals[operator].first,  a_value_human))
          errors.add(a_attr, locale.t(locals[operator].second, b_value_human))
        end
      end
      config = %(validate :#{method_name})
      class_eval(config)
    end
  end
end
