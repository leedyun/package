# frozen_string_literal: true

require_relative '../label'
require_relative '../label_event'
require_relative '../milestone'

module Gitlab
  module Triage
    module Resource
      module Shared
        module Issuable
          SourceTooDeep = Class.new(RuntimeError)
          MAX_PARENT_LOOKUP = 10

          def milestone
            @milestone ||=
              resource[:milestone] &&
              Milestone.new(resource[:milestone], parent: self)
          end

          # This will be more useful when we have:
          # https://gitlab.com/gitlab-org/gitlab-ce/issues/51011
          def labels
            @labels ||= resource[:labels] # an array of label names
              .map { |label| Label.new({ name: label }, parent: self) }
          end

          # Make this an alias of `labels` when we have:
          # https://gitlab.com/gitlab-org/gitlab-ce/issues/51011
          def labels_with_details
            # Labels can be deleted thus event.label can be nil
            @labels_with_details ||= label_events
              .select { |event| event.action == 'add' && event.label }
              .map(&:label)
              .sort_by(&:added_at)
              .reverse
              .uniq(&:name)
              .select { |label| resource[:labels].include?(label.name) }
          end

          def label_events
            @label_events ||= query_label_events
              .map { |label_event| LabelEvent.new(label_event, parent: self) }
          end

          def labels_chronologically
            @labels_chronologically ||= labels_with_details.sort_by(&:added_at)
          end

          def state
            @state ||= resource.dig(:state)
          end

          def author
            @author ||= resource.dig(:author, :username)
          end

          def project_path
            @project_path ||=
              request_project(resource[:project_id])[:path_with_namespace]
          end

          def full_resource_reference
            @full_resource_reference ||= resource.dig(:references, :full)
          end

          def root_id(
            resource: source_resource,
            max_levels: MAX_PARENT_LOOKUP)
            raise SourceTooDeep if max_levels <= 0

            # In projects, the reference to the namespace's parent ID is `namespace.parent_id`
            # but in groups, the reference is directly in `parent_id`
            parent_id = resource.dig(:namespace, :parent_id) || resource.dig(:parent_id)

            if parent_id
              root_id(
                resource: request_group(parent_id),
                max_levels: max_levels - 1)
            else
              resource.dig(:namespace, :id) || resource[:id]
            end
          end

          private

          def query_label_events
            network.query_api_cached(
              resource_url(sub_resource_type: 'resource_label_events'))
          end

          def request_project(project_id)
            network.query_api_cached(project_url(project_id)).first
          end

          def request_group(group_id)
            network.query_api_cached(group_url(group_id)).first
          end

          def group_url(group_id)
            Gitlab::Triage::UrlBuilders::UrlBuilder.new(
              network_options: network.options,
              source: 'groups',
              source_id: group_id
            ).build
          end

          def project_url(project_id)
            Gitlab::Triage::UrlBuilders::UrlBuilder.new(
              network_options: network.options,
              source: 'projects',
              source_id: project_id
            ).build
          end
        end
      end
    end
  end
end
