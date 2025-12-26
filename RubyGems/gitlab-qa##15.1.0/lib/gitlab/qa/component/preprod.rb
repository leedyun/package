# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class Preprod < Staging
        ADDRESS = Runtime::Env.preprod_url
      end
    end
  end
end
