# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class StagingRef < Staging
        ADDRESS = Runtime::Env.staging_ref_url
        GEO_SECONDARY_ADDRESS = Runtime::Env.geo_staging_ref_url
      end
    end
  end
end
