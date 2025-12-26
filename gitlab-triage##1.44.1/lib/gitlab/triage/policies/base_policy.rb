# frozen_string_literal: true

module Gitlab
  module Triage
    module Policies
      class BasePolicy
        InvalidPolicyError = Class.new(StandardError)

        attr_reader :type, :policy_spec, :resources, :network
        attr_accessor :summary

        def initialize(type, policy_spec, resources, network)
          @type = type
          @policy_spec = policy_spec
          @resources = resources
          @network = network
        end

        def validate!
          raise InvalidPolicyError, 'Policies that comment_on_summary must include summarize action' if comment_on_summary? && !summarize?
        end

        def name
          @name ||= policy_spec[:name] || "#{type}-#{object_id}"
        end

        def source
          case type
          when 'epics'
            'groups'
          else
            'projects'
          end
        end

        def source_id_sym
          case type
          when 'epics'
            :group_id
          else
            :project_id
          end
        end

        def actions
          @actions ||= policy_spec.fetch(:actions) { {} }
        end

        def summarize?
          actions.key?(:summarize)
        end

        def comment_on_summary?
          actions.key?(:comment_on_summary)
        end

        def comment?
          # The actual keys are strings
          (actions.keys.map(&:to_sym) - [:summarize, :comment_on_summary, :delete, :issue]).any?
        end

        def issue?
          actions.key?(:issue)
        end

        def delete?
          actions.key?(:delete) && actions[:delete]
        end

        def build_issue
          raise NotImplementedError
        end

        def build_summary
          raise NotImplementedError
        end
      end
    end
  end
end
