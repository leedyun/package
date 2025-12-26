require "active_record/type"

module ActiveRecord
  module FixIntegerLimit
    def initialize(*)
      super
      @limit ||= 8
      @range = min_value...max_value
    end
  end

  module Type
    class UnsignedInteger
      prepend FixIntegerLimit
    end
  end
end
