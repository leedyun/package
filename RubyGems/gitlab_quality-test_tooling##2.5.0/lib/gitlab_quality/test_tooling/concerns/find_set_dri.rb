# frozen_string_literal: true

require 'json'

module GitlabQuality
  module TestTooling
    module Concerns
      module FindSetDri
        def test_dri(product_group, stage, section)
          parse_json_with_sets
          fetch_section_sets(section)
          fetch_stage_sets(stage)
          fetch_group_sets(product_group)

          set_dris = if @group_sets.any?
                       @group_sets
                     elsif @stage_sets.any?
                       @stage_sets
                     elsif @section_sets.any?
                       @section_sets
                     else
                       @sets
                     end

          set_dris.sample['username']
        end

        private

        def parse_json_with_sets
          response = Support::HttpRequest.make_http_request(
            url: 'https://gitlab-org.gitlab.io/gitlab-roulette/roulette.json'
          )
          @sets = JSON.parse(response.body).select { |user| user['role'].include?('software-engineer-in-test') }
        end

        def fetch_section_sets(section)
          @section_sets = []
          return if section.nil?

          @section_sets = @sets.select do |user|
            user['role'].include?(section.split("_").map(&:capitalize).join(" "))
          end
        end

        def fetch_stage_sets(stage)
          @stage_sets = @sets.select do |user|
            user['role'].include?(stage.split("_").map(&:capitalize).join(" "))
          end
        end

        def fetch_group_sets(product_group)
          @group_sets = @stage_sets.select do |user|
            user['role'].downcase.tr(' ', '_').include?(product_group)
          end
        end
      end
    end
  end
end
