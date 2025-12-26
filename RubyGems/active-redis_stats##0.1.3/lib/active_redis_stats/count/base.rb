# frozen_string_literal: true

module ActiveRedisStats
  module Count
    class Base < ActiveRedisStats::Base

      class << self
        def primary_key(key)
          "ars:count:#{key}"
        end
      end

    end
  end
end
