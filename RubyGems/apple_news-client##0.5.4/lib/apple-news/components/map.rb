module AppleNewsClient
  module Component
    class Map < Base
      role "map"
      optional_properties :latitude, :longitude, :caption, :map_type,
                          :span

      optional_property :items, []
    end
  end
end
