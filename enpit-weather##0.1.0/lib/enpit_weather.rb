require "enpit_weather/version"
require 'httpclient'
require 'json'

module EnpitWeather
  class Weather

    def getCityWeather
      c = HTTPClient.new
      weather = Array.new
      ["2112669", "1850310", "1863501", "1853226", "2113014", "1850147", "1860291"].each do |city|
        w = c.get('http://api.openweathermap.org/data/2.5/forecast/daily?APPID=b13a40b93c4e20f046c45c3667b7d6a0&id=' + city + '&lang=ja&cnt=1&units').body
        weather.push(w)
      end
      weather
    end

    def displayCityWeather(data)
      data.each do |w_data|
        hash = JSON.parse(w_data)

        city = hash["city"]["name"]
        weather_main = hash["list"][0]["weather"][0]["main"]
        weather_desc = hash["list"][0]["weather"][0]["description"]

        $stdout.print "City: ", city, "\n"
        $stdout.print "Weather: ", weather_main, "\n"
        $stdout.print "Weather Description: ", weather_desc, "\n"
      end
    end

  end

end
