# frozen_string_literal: true

module ActiveRedisStats
  module Count
    class Get < ActiveRedisStats::Count::Base

      class << self
        def total(key)
          ActiveRedisDB::String
            .evaluate
            .find(primary_key(key)) || 0
        end

        def total_intervals(key, format: :month, offset: 0)
          keys = send("#{format}_keys", offset: offset)
          keys = keys.collect { |k| primary_key("#{key}:#{k}") }

          ActiveRedisDB::String
            .evaluate
            .find_each(*keys)
            .map(&:to_i)
        end
      end

    end
  end
end
