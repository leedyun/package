# frozen_string_literal: true

require_relative '../param_builders/date_param_builder'
require_relative 'base_query_param_builder'

module Gitlab
  module Triage
    module APIQueryBuilders
      class DateQueryParamBuilder < BaseQueryParamBuilder
        ATTRIBUTES = %w[updated_at created_at].freeze

        def self.applicable?(condition)
          ATTRIBUTES.include?(condition[:attribute].to_s) &&
            condition[:filter_in_ruby] != true
        end

        def initialize(condition_hash)
          date_param_builder = ParamBuilders::DateParamBuilder.new(ATTRIBUTES, condition_hash)

          super(build_param_name(condition_hash), date_param_builder.param_content)
        end

        def param_content
          param_contents
        end

        private

        def build_param_name(condition_hash)
          prefix = condition_hash[:attribute].to_s.delete_suffix('_at')
          suffix =
            case condition_hash[:condition].to_sym
            when :older_than
              'before'
            when :newer_than
              'after'
            end

          "#{prefix}_#{suffix}"
        end
      end
    end
  end
end
