# frozen_string_literal: true

module ActiveRedisStats
  module Count
    class Set < ActiveRedisStats::Count::Base

      class << self
        %i[decrement increment].each do |meth|
          define_method(meth) do |key, by: 1|
            ActiveRedisDB::String
              .send(meth, primary_key(key), by)
          end

          define_method("#{meth}_intervals") do |key, by: 1|
            ActiveRedisStats::Base::EXPIRES.each do |frmt, secs|
              ikey = "#{key}:#{interval_key(frmt)}"

              send(meth, ikey, by: by)
              expiration(ikey, secs)
            end
          end
        end
      end

    end
  end
end
