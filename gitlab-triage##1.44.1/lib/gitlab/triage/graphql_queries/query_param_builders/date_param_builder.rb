# frozen_string_literal: true

require_relative '../../param_builders/date_param_builder'
require_relative 'base_param_builder'

module Gitlab
  module Triage
    module GraphqlQueries
      module QueryParamBuilders
        class DateParamBuilder < BaseParamBuilder
          ATTRIBUTES = %w[updated_at created_at merged_at].freeze

          def initialize(condition_hash)
            date_param_builder = ParamBuilders::DateParamBuilder.new(ATTRIBUTES, condition_hash)

            super(build_param_name(condition_hash), date_param_builder.param_content)
          end

          private

          def build_param_name(condition_hash)
            prefix = condition_hash[:attribute].to_s.delete_suffix('_at')
            suffix =
              case condition_hash[:condition].to_sym
              when :older_than
                'Before'
              when :newer_than
                'After'
              end

            "#{prefix}#{suffix}"
          end
        end
      end
    end
  end
end
