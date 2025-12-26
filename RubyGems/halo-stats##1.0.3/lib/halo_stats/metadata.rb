module HaloStats
  class Metadata
    require 'takeout'
    attr_accessor :metadata_client
    
    def initialize(options={})
      title = 'h5'
      key = options[:api_key]
      metadata_prefix = "/metadata/#{title}/metadata"
      metadata_schemas = { get: {
                            campaign_missions: "#{metadata_prefix}/campaign-missions",
                            commendations: "#{metadata_prefix}/commendations",
                            csr_designations: "#{metadata_prefix}/csr-designations",
                            enemies: "#{metadata_prefix}/enemies",
                            flexible_stats: "#{metadata_prefix}/flexible-stats",
                            game_base_variants: "#{metadata_prefix}/game-base-variants",
                            game_variants: "#{metadata_prefix}/game-variants/{{id}}",
                            impulses: "#{metadata_prefix}/impulses",
                            map_variants: "#{metadata_prefix}/map-variants/{{id}}",
                            maps: "#{metadata_prefix}/maps",
                            medals: "#{metadata_prefix}/medals",
                            playlists: "#{metadata_prefix}/playlists",
                            requisition_packs: "#{metadata_prefix}/requisition-packs/{{id}}",
                            requisitions: "#{metadata_prefix}/requisitions/{{id}}",
                            seasons: "#{metadata_prefix}/seasons", 
                            skulls: "#{metadata_prefix}/skulls",
                            spartan_ranks: "#{metadata_prefix}/spartan-ranks",
                            team_colors: "#{metadata_prefix}/team-colors",
                            vehicles: "#{metadata_prefix}/vehicles",
                            weapons: "#{metadata_prefix}/weapons"
                        }
                      }

      self.metadata_client = Takeout::Client.new(uri: "www.haloapi.com", schemas: metadata_schemas, headers: {'Ocp-Apim-Subscription-Key' => key}, ssl: true)

      return self
    end

    def get_map_variants(id)
      return metadata_client.get_map_variants(id: id).body
    end

    def get_game_variants(id)
      return metadata_client.get_game_variants(id: id).body
    end

    def get_requisition_packs(id)
      return metadata_client.get_requisition_packs(id: id).body
    end

    def get_requisitions(id)
      return metadata_client.get_requisitions(id: id).body
    end

    def method_missing(meth, *args, &block)
      return self.metadata_client.send(meth).body
    end
  end
end