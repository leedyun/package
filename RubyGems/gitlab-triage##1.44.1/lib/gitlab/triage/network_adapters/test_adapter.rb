# frozen_string_literal: true

require 'httparty'

require_relative 'base_adapter'

module Gitlab
  module Triage
    module NetworkAdapters
      class TestAdapter < BaseAdapter
        def get(_token, url)
          results =
            case url
            when %r{\Ahttps://gitlab.com/v4/issues?per_page=100}
              [
                { id: 1, title: 'First issue' }
              ]
            else
              []
            end

          {
            more_pages: false,
            next_page_url: nil,
            results: results,
            ratelimit_remaining: 600,
            ratelimit_reset_at: Time.now
          }
        end

        def post(_token, _url, _body)
          {
            results: {},
            ratelimit_remaining: 600,
            ratelimit_reset_at: Time.now
          }
        end
      end
    end
  end
end
