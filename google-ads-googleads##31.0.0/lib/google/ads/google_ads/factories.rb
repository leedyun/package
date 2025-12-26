require "google/ads/google_ads/version_alternate"

require "google/ads/google_ads/factories/v16/resources"
require "google/ads/google_ads/factories/v16/services"
require "google/ads/google_ads/factories/v16/enums"
require "google/ads/google_ads/factories/v16/operations"

require "google/ads/google_ads/factories/v17/resources"
require "google/ads/google_ads/factories/v17/services"
require "google/ads/google_ads/factories/v17/enums"
require "google/ads/google_ads/factories/v17/operations"

require "google/ads/google_ads/factories/v18/resources"
require "google/ads/google_ads/factories/v18/services"
require "google/ads/google_ads/factories/v18/enums"
require "google/ads/google_ads/factories/v18/operations"

module Google
  module Ads
    module GoogleAds
      module Factories
        Factory = Struct.new(:resources, :services, :enums, :operations)

        FACTORY_V16 = Factory.new(
          V16::Resources,
          V16::Services,
          V16::Enums,
          V16::Operations
        ).freeze

        FACTORY_V17 = Factory.new(
          V17::Resources,
          V17::Services,
          V17::Enums,
          V17::Operations
        ).freeze

        FACTORY_V18 = Factory.new(
          V18::Resources,
          V18::Services,
          V18::Enums,
          V18::Operations
        ).freeze

        VERSIONS = [

          :V16,

          :V17,

          :V18

        ]

        HIGHEST_VERSION = :V18

        def self.version_alternate_for(type)
          unless [:resources, :services, :enums, :operations].include?(type)
            raise ArgumentError.new(
              "Dont have version alternate for #{type}, valid values are :resources, :services, :enums, :operations,  got #{type}"
            )
          end

          VersionAlternate.new(
            FACTORY_V18.public_send(type),
            {

              V16: FACTORY_V16.public_send(type),

              V17: FACTORY_V17.public_send(type),

              V18: FACTORY_V18.public_send(type)

            }
          )
        end

        def self.versions
        end

        def self.at_version(version)
          case version

          when :V16
            FACTORY_V16

          when :V17
            FACTORY_V17

          when :V18
            FACTORY_V18

          else
            raise ArgumentError.new("Got unkown version: #{version}")
          end
        end
      end
    end
  end
end
