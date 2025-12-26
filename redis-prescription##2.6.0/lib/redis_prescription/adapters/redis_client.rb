# frozen_string_literal: true

require_relative "../errors"

class RedisPrescription
  module Adapters
    # redis-client adapter
    module RedisClient
      class << self
        def adapts?(redis)
          return true if defined?(::RedisClient) && redis.is_a?(::RedisClient)
          return true if defined?(::RedisClient::Decorator::Client) && redis.is_a?(::RedisClient::Decorator::Client)

          false
        end

        def eval(redis, script, keys, argv)
          redis.call("EVAL", script, keys.size, *keys, *argv)
        rescue ::RedisClient::CommandError => e
          raise CommandError, e.message
        end

        def evalsha(redis, digest, keys, argv)
          redis.call("EVALSHA", digest, keys.size, *keys, *argv)
        rescue ::RedisClient::CommandError => e
          raise CommandError, e.message
        end
      end
    end
  end
end
