require 'fortnite_api/version'
require 'net/http'
require 'uri'
require 'json'
require 'fortnite_api/player'
require 'fortnite_api/global_solo'
require 'fortnite_api/global_duo'
require 'fortnite_api/global_squad'
require 'fortnite_api/current_solo'
require 'fortnite_api/current_duo'
require 'fortnite_api/current_squad'

module FortniteApi
     class Api
          attr_accessor :api_key
          def initialize(api_key = nil)
               @api_key = !api_key.nil? ? api_key : raise(ArgumentError, "API Key not defined: add your API Key'")
          end
          
          def get_json(platform = nil, nickname = nil)
               platform = !platform.nil? && (platform == "pc" || platform == "xbl" || platform == "psn") ? platform : raise(ArgumentError, "Platform not defined: add your plaform")
               nickname = !nickname.nil? ? nickname : raise(ArgumentError, "Nickame not defined: add your Fortnite nickname")
               uri = URI.parse("https://api.fortnitetracker.com/v1/profile/#{platform}/#{nickname}")
               http = Net::HTTP.new(uri.host, uri.port)
               http.use_ssl = true      
               request = Net::HTTP::Get.new(uri.request_uri)
               request.add_field("TRN-Api-Key", @api_key)
               response = http.request(request)
               json = JSON.parse(response.body)
               Player.new(json)
          end
     end
end