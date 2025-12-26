module HaloStats
  class Stats
    require 'takeout'
    attr_accessor :stats_client

    GAME_TYPES = [:arena, :warzone, :campaign, :custom_game]
    
    def initialize(options={})
      title = 'h5'
      key = options[:api_key]
      stats_prefix = "/stats/#{title}"
      stats_schemas = { get: {
                          player_matches: "#{stats_prefix}/players/{{gamertag}}/matches",
                          arena_matches: "#{stats_prefix}/arena/matches/{{id}}",
                          campaign_matches: "#{stats_prefix}/campaign/matches/{{id}}",
                          warzone_matches: "#{stats_prefix}/warzone/matches/{{id}}",
                          custom_game_matches: "#{stats_prefix}/custom/matches/{{id}}",
                          arena_service_record: "#{stats_prefix}/servicerecords/arena",
                          campaign_service_record: "#{stats_prefix}/servicerecords/campaign",
                          warzone_service_record: "#{stats_prefix}/servicerecords/warzone",
                          custom_game_service_record: "#{stats_prefix}/servicerecords/custom"
                        }
                      }

      self.stats_client = Takeout::Client.new(uri: "www.haloapi.com", schemas: stats_schemas, headers: {'Ocp-Apim-Subscription-Key' => key}, ssl: true)

      generate_carnage_report_methods
      generate_service_record_methods

      return self
    end

    def get_matches(gamertag)
      return stats_client.get_player_matches(gamertag: gamertag).body
    end

    def generate_carnage_report_methods
      GAME_TYPES.each do |game_type|
        self.define_singleton_method("get_#{game_type.to_s}_carnage_report") do |id, &block|
          return stats_client.send("get_#{game_type.to_s}_matches".to_sym, {id: id}).body
        end
      end
    end

    def generate_service_record_methods
      GAME_TYPES.each do |game_type|
        self.define_singleton_method("get_#{game_type.to_s}_service_record") do |gamertags, &block|
          return stats_client.send("get_#{game_type.to_s}_service_record".to_sym, {players: [gamertags].flatten(1).join(',')}).body
        end
      end
    end
  end
end