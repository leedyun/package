require "alias_class/version"

module AliasClass
  def self.included(base_class)
    base_class.class_eval do
      def self.alias_class(original_class, new_class)
        self.const_set(new_class, original_class)
      end
    end
  end
end
