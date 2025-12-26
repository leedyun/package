require 'movingsign_api/commands/internal/utilities'

module MovingsignApi
  module PrettyKeyable
    include Utilities

    # @!visibility private
    def self.included(other)
      other.class_variable_set(:@@KEYS, [])
      other.class_variable_set(:@@CODES, [])

      other.extend ClassMethods
    end

    # @!visibility private
    def to_bytes
      string_to_ascii_bytes self.class.codes[self.class.keys.index(self.key)]
    end

    private

    module ClassMethods
      # registers the specified key and code pair as synonymous
      def register(key, code)
        keys << key
        codes << code

        define_singleton_method(key) do
          key
        end
      end

      def parse_to_key(input)
        if index = (keys.index(input) || codes.index(input))
          keys[index]
        else
          nil
        end
      end

      def keys
        class_variable_get(:@@KEYS)
      end

      def codes
        class_variable_get(:@@CODES)
      end
    end
  end
end