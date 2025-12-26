# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Release < Staging
        ADDRESS = Runtime::Env.release_url
      end
    end
  end
end
