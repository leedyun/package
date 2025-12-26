# frozen_string_literal: true

require_relative "../errors"

class RedisPrescription
  module Adapters
    # redis-rb adapter
    module Redis
      class << self
        def adapts?(redis)
          defined?(::Redis) && redis.is_a?(::Redis)
        end

        def eval(redis, script, keys, argv)
          redis.eval(script, keys, argv)
        rescue ::Redis::CommandError => e
          raise CommandError, e.message
        end

        def evalsha(redis, digest, keys, argv)
          redis.evalsha(digest, keys, argv)
        rescue ::Redis::CommandError => e
          raise CommandError, e.message
        end
      end
    end
  end
end
