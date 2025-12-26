# -*- coding: utf-8 -*-
module Cinch
  module Plugins
    class Weatherman
      # Class to manage information for current conditions
      class Weather
        attr_reader :location

        def initialize(location)
          @data = WeatherUnderground::Base.new.CurrentObservations(location)
          @location = @data.display_location.first.full
          @temp = @data.temp_f
          @conditions = @data.weather.downcase
          @updated = Time.parse(@data.observation_time).ago.to_words
        end

        def to_s
          "In #{@location} it is #{@conditions} " \
          "and #{@temp}F (last updated about #{@updated})."
        end
      end
    end
  end
end
