# frozen_string_literal: true

module ActiveRedisStats
  module Rank
    class Base < ActiveRedisStats::Base

      class << self
        def primary_key(key)
          "ars:rank:#{key}"
        end
      end

    end
  end
end
