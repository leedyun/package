# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class Chaos < Praefect
            def initialize
              super

              @praefect_addr = "chaos.test"
              @database_addr = "chaos.test"
              @primary_node_addr = "chaos.test"
              @primary_node_port = 8076
              @secondary_node_addr = "chaos.test"
              @secondary_node_port = 8077
              @tertiary_node_addr = "chaos.test"
              @tertiary_node_port = 8078
            end

            def perform(release, *rspec_args)
              @chaos_node = Component::Chaos.new.tap(&:start)

              run_gitaly_cluster(release, rspec_args)
            ensure
              @chaos_node&.teardown
              @praefect_node&.teardown
              @sql_node&.teardown
              @gitaly_primary_node&.teardown
              @gitaly_secondary_node&.teardown
              @gitaly_tertiary_node&.teardown
            end
          end
        end
      end
    end
  end
end
