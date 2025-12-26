module HaloStats
  class Profile
    require 'takeout'
    attr_accessor :profile_client
    
    def initialize(options={})
      title = 'h5'
      key = options[:api_key]
      profile_prefix = "/profile/#{title}"
      profile_schemas = { get: {
                            emblem: "#{profile_prefix}/profiles/{{gamertag}}/emblem",
                            spartan_image: "#{profile_prefix}/profiles/{{gamertag}}/spartan"
                        }
                      }

      self.profile_client = Takeout::Client.new(uri: "www.haloapi.com", schemas: profile_schemas, headers: {'Ocp-Apim-Subscription-Key' => key}, ssl: true)

      return self
    end

    def get_emblem(gamertag, size=nil)
      return profile_client.get_emblem(gamertag: gamertag, size: size).headers[:Location]
    end

    def get_spartan_image(gamertag, size=nil, crop=nil)
      return profile_client.get_spartan_image(gamertag: gamertag, size: size, crop: crop).headers[:Location]
    end
  end
end