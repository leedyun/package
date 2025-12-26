# frozen_string_literal: true

module ActiveRedisStats
  class Base

    TIME ||= Time.current.utc.freeze
    FORMATS ||= {
      hour: 'year-month-day-hour-minute',
      day: 'year-month-day-hour',
      month: 'year-month-day',
      year: 'year-month',
      all: 'year',
      inf: 'inf'
    }.freeze
    EXPIRES ||= {
      hour: 25_200,      # 7 hours
      day: 691_200,      # 8 days
      month: 31_708_800, # 367 days
      year: 317_174_400, # 3671 days
      all: 317_174_400,  # 3671 days
      inf: nil           # never
    }.freeze

    class << self
      def interval_key(format, time: TIME)
        format = format.to_sym
        return "#{format}:#{format}" if format == :inf

        interval = time.format(FORMATS[format])
        "#{format}:#{interval}"
      end

      def hour_key(offset: 0)
        interval_key(:day, time: offset.minutes.ago(TIME))
      end

      def hour_keys(offset: 0)
        adj = (30 * offset)
        max = 29 + adj
        min = 0 + adj

        max.downto(min).collect do |num|
          interval_key(:hour, time: num.minutes.ago(TIME))
        end
      end

      def day_key(offset: 0)
        interval_key(:month, time: offset.days.ago(TIME))
      end

      def day_keys(offset: 0)
        boy = offset.days.ago(TIME).beginning_of_day

        0.upto(23).collect do |num|
          interval_key(:day, time: num.hours.from_now(boy))
        end
      end

      def month_key(offset: 0)
        interval_key(:year, time: offset.months.ago(TIME))
      end

      def month_keys(offset: 0)
        boy = offset.months.ago(TIME).beginning_of_month
        max = boy.end_of_month.day - 1

        0.upto(max).collect do |num|
          interval_key(:month, time: num.days.from_now(boy))
        end
      end

      def year_key(offset: 0)
        interval_key(:all, time: offset.years.ago(TIME))
      end

      def year_keys(offset: 0)
        boy = offset.years.ago(TIME).beginning_of_year

        0.upto(11).collect do |num|
          interval_key(:year, time: num.months.from_now(boy))
        end
      end

      # rubocop:disable Lint/UnusedMethodArgument
      def all_key(offset: 0)
        interval_key(:inf)
      end
      # rubocop:enable Lint/UnusedMethodArgument

      def all_keys(offset: 0)
        max = 9 + offset
        min = 0 + offset

        max.downto(min).collect do |num|
          interval_key(:all, time: num.years.ago(TIME))
        end
      end

      def expiration(key, seconds)
        return if seconds.nil?

        ActiveRedisDB::Key
          .expire(primary_key(key), seconds)
      end
    end

  end
end
