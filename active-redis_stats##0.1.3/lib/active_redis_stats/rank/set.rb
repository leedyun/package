# frozen_string_literal: true

module ActiveRedisStats
  module Rank
    class Set < ActiveRedisStats::Rank::Base

      class << self
        %i[decrement increment].each do |meth|
          define_method(meth) do |key, val, by: 1|
            ActiveRedisDB::SortedSet
              .send(meth, primary_key(key), val.to_s, by)
          end

          define_method("#{meth}_intervals") do |key, val, by: 1|
            ActiveRedisStats::Base::EXPIRES.each do |frmt, secs|
              ikey = "#{key}:#{interval_key(frmt)}"

              send(meth, ikey, val, by: by)
              expiration(ikey, secs)
            end
          end
        end
      end

    end
  end
end
