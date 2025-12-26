# -*- coding: utf-8 -*-
module Cinch
  module Plugins
    class Weatherman
      # Class to manage information on future conditions
      class Forecast
        def initialize(location)
          @data = WeatherUnderground::Base.new.SimpleForecast(location).days[1]

          fail ArgumentError if @data.nil?

          @location = Weather.new(location).location
          @forecast = @data.conditions.downcase
          @temp_high = @data.high.fahrenheit.round
          @temp_low = @data.low.fahrenheit.round
        end

        def to_s
          "Tommorrow in #{@location}; #{@forecast}, " \
          "high of #{@temp_high}F, low of #{@temp_low}F."
        end

        def append
          to_s.gsub(" in #{@location}", '')
        end
      end
    end
  end
end
