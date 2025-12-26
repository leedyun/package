# frozen_string_literal: true

class RedisPrescription
  # Top-level error class for all RedisPrescription errors
  class Error < StandardError; end

  # Redis command error wrapper, `#cause` will be `Redis::CommandError` or
  # `RedisClient::CommandError`.
  class CommandError < Error; end

  # Lua script eval/evalsha failure
  class ScriptError < Error
    # rubocop:disable Layout/LineLength
    LUA_ERROR_MESSAGE = %r{
      # * Error compiling script:
      # ** Redis 6.0, 6.2, 7.0
      # *** ERR Error compiling script (new function): user_script:7: unexpected symbol near '!'
      # * Error running script:
      # ** Redis 6.0, 6.2
      # *** ERR Error running script (call to f_64203334c42d5690c2d008a78aa7789f5b83e5bb): @user_script:4: user_script:4: attempt to perform arithmetic on a string value
      # ** Redis 7.0
      # *** ERR user_script:4: attempt to perform arithmetic on a string value script: 64203334c42d5690c2d008a78aa7789f5b83e5bb, on @user_script:4.
      \A
      ERR\s
      (?:
        Error\scompiling\sscript\s\([^)]+\):\s          # Redis 6.0, 6.2, 7.0
        .+:(?<loc>\d+):\s                               # Redis 6.0, 6.2, 7.0
        (?<message>.+)                                  # Redis 6.0, 6.2, 7.0
      |
        (?:Error\srunning\sscript\s\([^)]+\):\s@\S+\s)? # Redis 6.0, 6.2
        .+:(?<loc>\d+):\s                               # Redis 6.0, 6.2, 7.0
        (?<message>.+?)                                 # Redis 6.0, 6.2, 7.0
        (?::\s\h+,\son\s@[^:]+:\d+\.)?                  # Redis 7.0
      )
      \z
    }x.freeze
    private_constant :LUA_ERROR_MESSAGE
    # rubocop:enable Layout/LineLength

    # Lua script source
    #
    # @return [String]
    attr_reader :source

    # Line of code where error was encountered
    #
    # @return [Integer?]
    attr_reader :loc

    # @param message [String]
    # @param source [#to_s]
    def initialize(message, source)
      @source = -source.to_s

      if (parsed = LUA_ERROR_MESSAGE.match(message))
        @loc    = parsed[:loc].to_i
        message = [parsed[:message], excerpt(@source, @loc)].compact.join("\n\n")
      end

      super(message)
    end

    private

    def excerpt(source, loc)
      lines  = excerpt_lines(source, loc)
      gutter = lines.map(&:first).max.to_s.length

      lines.map! do |(pos, line)|
        format(pos == loc ? "\t%#{gutter}d > %s" : "\t%#{gutter}d | %s", pos, line).rstrip
      end

      lines.join("\n")
    rescue => e
      warn "Failed extracting source excerpt: #{e.message}"
      nil
    end

    def excerpt_lines(source, loc)
      lines  = source.lines
      pos    = loc - 1 # reported line of code is 1-offset
      min    = pos - 2 # 2 lines of head context
      max    = pos + 2 # 2 lines of tail context

      min = 0              if min.negative?
      max = lines.size - 1 if lines.size <= max

      (min..max).map { |i| [i.succ, lines[i]] }
    end
  end
end
