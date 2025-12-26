require "dark_sky_weather/version"
require "unirest"

module DarkSkyWeather
  
  class CurrentWeather
    attr_reader :time, :summary, :icon, :precipProbability, :temperature, :apparentTemperature, :humidity, :temperatureMin, :temperatureMax, :precipType

    def initialize(args)
      @time                = args["time"]
      @summary             = args["summary"]
      @icon                = args["icon"]
      @precipProbability   = args["precipProbability"]
      @temperature         = args["temperature"]
      @apparentTemperature = args["apparentTemperature"]
      @humidity            = args["humidity"]
      @temperatureMin      = args["temperatureMin"]
      @temperatureMax      = args["temperatureMax"]
      @precipType          = args["precipType"]
    end

    def self.currently(api_key, latitude, longitude)
      latitude  = latitude.to_f
      longitude = longitude.to_f

      current_weather = Unirest.get("https://api.forecast.io/forecast/#{api_key}/#{latitude},#{longitude}").body["currently"]
      return CurrentWeather.new(current_weather)
    end

    def self.daily(api_key, latitude, longitude)
      latitude  = latitude.to_f
      longitude = longitude.to_f

      weeks_weather_array = Unirest.get("https://api.forecast.io/forecast/#{api_key}/#{latitude},#{longitude}").body["daily"]["data"]
      weeks_forecast = []
      weeks_weather_array.each do |daily_weather|
        weeks_forecast << CurrentWeather.new(daily_weather)
      end
      weeks_forecast
    end

    def to_date
      format_seconds.strftime("%A, %d %b %Y %l:%M %p")
    end

    def abbreviated_week_day
      if format_seconds.strftime("%A").downcase == "thursday" || "tuesday"
        format_seconds.strftime("%A").slice(0, 4)
      else
        format_seconds.strftime("%A").slice(0, 3)
      end
    end

    def temp
      @temperature.round || @temperatureMin.round || @temperatureMax.round
    end

    def humidity
      "#{find_percent(@humidity)}%"
    end

    def precip
      "#{find_percent(@precipProbability)}%"
    end

    
    private

    def format_seconds
      Time.at(@time)
    end

    def find_percent(number)
      (number * 100).to_i
    end

  end
end

