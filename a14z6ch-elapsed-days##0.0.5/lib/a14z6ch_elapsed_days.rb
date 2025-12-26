require "a14z6ch_elapsed_days/version"
require 'active_support'
require 'active_support/core_ext'
require 'time'
require 'colorize'
require 'thor'

I18n.enforce_available_locales = false

#
# To calculate elapsed days.
#
module A14z6chElapsedDays 
  class Cli < Thor

    desc "version", "Show version"
    def version
      puts "a14z6ch appilication version : #{A14z6chElapsedDays::VERSION}"
    end

    desc "from DATE", "calculate elapsed days from target date."
    #
    # calculating method
    # @param from date
    #
    def from(date)
      begin
        puts "#{calc(date, Time.now.to_s).to_s(:delimited)} days elapsed from the day \"#{date}\" to NOW.".colorize(:light_magenta)
      rescue ArgumentError => e
        if e.message.nil?
          puts "given date is not valid.".colorize(:light_blue)
        else
          puts e.message.colorize(:light_blue)
        end
      end
    end

    desc "between FROM_DATE and TO_DATE", "calculate elapsed days from FROM date to TO date"
    #
    #
    #
    def between(from, to)
      begin
        puts "#{calc(from, to).to_s(:delimited)} days elapsed from the day \"#{from}\" to \"#{to}\".".colorize(:light_magenta)
      rescue ArgumentError => e
        if e.message.nil?
          puts "given date is not valid.".colorize(:light_blue)
        else
          puts e.message.colorize(:light_blue)
        end
      end
    end

    private
      def calc(from, to)
        elapsed_seconds = Time.parse(to) - Time.parse(from)
        if elapsed_seconds < 0
          raise ArgumentError.new("TO DATE must be later than FROM DATE")
        else
          (elapsed_seconds / 60 / 60 / 24).to_i
        end
      end
  end
end
