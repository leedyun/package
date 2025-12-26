# frozen_string_literal: true

require_relative "./adapters/redis"
require_relative "./adapters/redis_client"
require_relative "./adapters/redis_namespace"

class RedisPrescription
  # @api internal
  module Adapters
    class << self
      def [](redis)
        return Adapters::Redis if Adapters::Redis.adapts?(redis)
        return Adapters::RedisClient if Adapters::RedisClient.adapts?(redis)
        return Adapters::RedisNamespace if Adapters::RedisNamespace.adapts?(redis)

        raise TypeError, "Unsupported redis client: #{redis.class}"
      end
    end
  end
end
