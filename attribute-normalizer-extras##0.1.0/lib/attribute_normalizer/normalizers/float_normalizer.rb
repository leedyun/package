module AttributeNormalizer
  module Normalizers
    # Accept an input value of various types and coerce it into a float.
    #
    # Valid types for coersion are: String, Numeric, and NilClass.
    #
    # = Options
    # allow_blank::
    #   Will not attempt to coerce nil or '' to a float if this evaluates to a
    #   truthy value. DEFAULT: false
    #
    # = Notes
    #   This normalizer does not handle negative values, or perform any rounding
    #
    # = Usage
    # AttributeNormalizer::Normalizers::FloatNormalizer.normalize('$1,500.00')
    module FloatNormalizer
      DEFAULTS = {
        blank: false
      }.freeze

      class << self
        def normalize(value, opts = {})
          case value
          when String
            handle_string(value, opts)
          when Numeric
            value.to_f
          when NilClass
            handle_nil(opts)
          else
            invalid_type!(value)
          end
        end

        private

        def handle_string(value, opts = {})
          if opts.fetch(:allow_blank, DEFAULTS[:blank]) && blank?(value)
            value
          else
            # Strip all characters except digits or '.'.
            # Be warned that this will coerce '' or nil to 0.00.
            # Use allow_blank: true if you don't want this behaviour.
            value.gsub(/[^\d.]/, '').to_f
          end
        end

        def handle_nil(opts = {})
          if opts.fetch(:allow_blank, DEFAULTS[:blank])
            nil
          else
            nil.to_f
          end
        end

        def invalid_type!(value)
          raise ArgumentError, "must pass a Numeric or a String, got: #{value.class}"
        end

        # This gem doesn't have a dependency on ActiveSupport - I'd rather not add
        # the dependency just for String#blank?.
        def blank?(value)
          value.nil? || value.empty?
        end
      end
    end
  end
end
