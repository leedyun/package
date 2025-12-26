# frozen_string_literal: true

require "digest/sha1"

require_relative "./redis_prescription/adapters"
require_relative "./redis_prescription/errors"
require_relative "./redis_prescription/version"

# Lua script executor for redis.
#
# Instead of executing script with `EVAL` everytime - loads script once
# and then runs it with `EVALSHA`.
#
# @example Usage
#
#     redis  = Redis.new
#     script = RedisPrescription.new("return ARGV[1] + ARGV[2]")
#     script.call(redis, argv: [2, 2]) # => 4
class RedisPrescription
  # Redis error fired when script ID is unkown.
  NOSCRIPT = "NOSCRIPT"
  private_constant :NOSCRIPT

  EMPTY_LIST = [].freeze
  private_constant :EMPTY_LIST

  # Lua script source.
  # @return [String]
  attr_reader :source

  # Lua script SHA1 digest.
  # @return [String]
  attr_reader :digest

  # @param source [#to_s] Lua script
  def initialize(source)
    @source = -source.to_s
    @digest = Digest::SHA1.hexdigest(@source).freeze
  end

  # Executes script and return result of execution.
  # @param redis [Redis, RedisClient]
  # @param keys [Array] keys to pass to the script
  # @param argv [Array] arguments to pass to the script
  # @raise [TypeError] if given redis client is not supported
  # @raise [ScriptError] if script execution failed
  # @return depends on the script
  def call(redis, keys: EMPTY_LIST, argv: EMPTY_LIST)
    evalsha_with_fallback(Adapters[redis], redis, keys, argv)
  rescue CommandError => e
    raise ScriptError.new(e.message, @source)
  end

  private

  def evalsha_with_fallback(adapter, redis, keys, argv)
    adapter.evalsha(redis, @digest, keys, argv)
  rescue CommandError => e
    raise unless e.message.include?(NOSCRIPT)

    adapter.eval(redis, @source, keys, argv)
  end
end
