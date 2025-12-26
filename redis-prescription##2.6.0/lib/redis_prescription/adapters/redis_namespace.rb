# frozen_string_literal: true

require_relative "../errors"

class RedisPrescription
  module Adapters
    # redis-namespace adapter
    module RedisNamespace
      class << self
        def adapts?(redis)
          defined?(::Redis::Namespace) && redis.is_a?(::Redis::Namespace)
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
