# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Production < Staging
        ADDRESS = Runtime::Env.production_url
      end
    end
  end
end
