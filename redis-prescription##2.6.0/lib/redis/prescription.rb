# frozen_string_literal: true

require_relative "../redis_prescription"

class Redis
  # @deprecated Use ::RedisPrescription
  class Prescription < RedisPrescription
    class << self
      # Controls if deprecation warnings should be silenced or not.
      # Defaults to `false`.
      #
      # @return [Boolean]
      attr_accessor :silence_deprecation_warning
    end

    self.silence_deprecation_warning = false

    def initialize(*)
      super

      return if self.class.silence_deprecation_warning

      warn "#{self.class} usage was deprecated, please use RedisPrescription instead"
    end
  end
end
