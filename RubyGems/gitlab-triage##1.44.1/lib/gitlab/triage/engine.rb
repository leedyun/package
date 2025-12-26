# frozen_string_literal: false

require 'active_support/all'
require 'active_support/inflector'

require_relative 'expand_condition'
require_relative 'filters/issue_date_conditions_filter'
require_relative 'filters/merge_request_date_conditions_filter'
require_relative 'filters/branch_date_filter'
require_relative 'filters/branch_protected_filter'
require_relative 'filters/votes_conditions_filter'
require_relative 'filters/no_additional_labels_conditions_filter'
require_relative 'filters/author_member_conditions_filter'
require_relative 'filters/assignee_member_conditions_filter'
require_relative 'filters/discussions_conditions_filter'
require_relative 'filters/ruby_conditions_filter'
require_relative 'limiters/date_field_limiter'
require_relative 'action'
require_relative 'policies/rule_policy'
require_relative 'policies/summary_policy'
require_relative 'policies_resources/rule_resources'
require_relative 'policies_resources/summary_resources'
require_relative 'api_query_builders/date_query_param_builder'
require_relative 'api_query_builders/single_query_param_builder'
require_relative 'api_query_builders/multi_query_param_builder'
require_relative 'url_builders/url_builder'
require_relative 'network'
require_relative 'graphql_network'
require_relative 'rest_api_network'
require_relative 'network_adapters/httparty_adapter'
require_relative 'network_adapters/graphql_adapter'
require_relative 'graphql_queries/query_builder'
require_relative 'ui'

module Gitlab
  module Triage
    class Engine
      attr_reader :per_page, :policies, :options

      # This filter map is used to help make the filter_resource method
      # smaller. We loop through each of the keys (conditions) and map
      # that to the filters that will be used for it.
      FILTER_MAP = {
        date: {
          'branches' => Filters::BranchDateFilter,
          'issues' => Filters::IssueDateConditionsFilter,
          'merge_requests' => Filters::MergeRequestDateConditionsFilter
        },
        protected: Filters::BranchProtectedFilter,
        assignee_member: Filters::AssigneeMemberConditionsFilter,
        author_member: Filters::AuthorMemberConditionsFilter,
        discussions: Filters::DiscussionsConditionsFilter,
        no_additional_labels: Filters::NoAdditionalLabelsConditionsFilter,
        ruby: Filters::RubyConditionsFilter,
        votes: Filters::VotesConditionsFilter,
        upvotes: Filters::VotesConditionsFilter
      }.freeze

      DEFAULT_NETWORK_ADAPTER = Gitlab::Triage::NetworkAdapters::HttpartyAdapter
      DEFAULT_GRAPHQL_ADAPTER = Gitlab::Triage::NetworkAdapters::GraphqlAdapter
      ALLOWED_STATE_VALUES = {
        issues: %w[opened closed],
        merge_requests: %w[opened closed merged]
      }.with_indifferent_access.freeze
      MILESTONE_TIMEBOX_VALUES = %w[none any upcoming started].freeze
      ITERATION_SELECTION_VALUES = %w[none any].freeze
      EpicsTriagingForProjectImpossibleError = Class.new(StandardError)
      MultiPolicyInInjectionModeError = Class.new(StandardError)

      def initialize(policies:, options:, network_adapter_class: DEFAULT_NETWORK_ADAPTER, graphql_network_adapter_class: DEFAULT_GRAPHQL_ADAPTER)
        options.host_url = policies.delete(:host_url) { options.host_url }
        options.api_version = policies.delete(:api_version) { 'v4' }
        options.dry_run = ENV['TEST'] == 'true' if options.dry_run.nil?

        @per_page = policies.delete(:per_page) { 100 }
        @policies = policies
        @options = options
        @network_adapter_class = network_adapter_class
        @graphql_network_adapter_class = graphql_network_adapter_class

        assert_options!

        @options.source = @options.source.to_s

        require_ruby_files
      end

      def perform
        puts "Performing a dry run.\n\n" if options.dry_run

        puts Gitlab::Triage::UI.header("Triaging the `#{options.source_id}` #{options.source.singularize}", char: '=')
        puts

        resource_rules.each do |resource_type, policy_definition|
          next unless right_resource_type_for_resource_option?(resource_type)

          assert_epic_rule!(resource_type)

          puts Gitlab::Triage::UI.header("Processing summaries & rules for #{resource_type}", char: '-')
          puts

          process_summaries(resource_type, policy_definition[:summaries])
          process_rules(resource_type, policy_definition[:rules])
        end
      end

      def network
        @network ||= Network.new(restapi: restapi_network, graphql: graphql_network)
      end

      def restapi_network
        @restapi_network ||= RestAPINetwork.new(network_adapter)
      end

      def graphql_network
        @graphql_network ||= GraphqlNetwork.new(graphql_network_adapter)
      end

      private

      def assert_options!
        assert_all!
        assert_source!
        assert_source_id!
        assert_resource_reference!
      end

      # rubocop:disable Style/IfUnlessModifier
      def assert_all!
        return unless options.all

        if options.source
          raise ArgumentError, '--all-projects option cannot be used in conjunction with --source option!'
        end

        if options.source_id
          raise ArgumentError, '--all-projects option cannot be used in conjunction with --source-id option!'
        end

        if options.resource_reference # rubocop:disable Style/GuardClause
          raise ArgumentError, '--all-projects option cannot be used in conjunction with --resource-reference option!'
        end
      end
      # rubocop:enable Style/IfUnlessModifier

      def assert_source!
        return if options.source
        return if options.all

        raise ArgumentError, 'A source is needed (pass it with the `--source` option)!'
      end

      def assert_source_id!
        return if options.source_id
        return if options.all

        raise ArgumentError, 'A project or group ID is needed (pass it with the `--source-id` option)!'
      end

      def assert_resource_reference!
        return unless options.resource_reference

        if options.source == 'groups' && !options.resource_reference.start_with?('&')
          raise ArgumentError, "--resource-reference can only start with '&' when --source=groups is passed ('#{options.resource_reference}' passed)!"
        end

        if options.source == 'projects' && !options.resource_reference.start_with?('#', '!') # rubocop:disable Style/GuardClause
          raise(
            ArgumentError,
            "--resource-reference can only start with '#' or '!' when --source=projects is passed " \
              "('#{options.resource_reference}' passed)!"
          )
        end
      end

      def require_ruby_files
        options.require_files.each(&method(:require))
      end

      def right_resource_type_for_resource_option?(resource_type)
        return true unless options.resource_reference

        resource_reference = options.resource_reference

        case resource_type
        when 'issues'
          resource_reference.start_with?('#')
        when 'merge_requests'
          resource_reference.start_with?('!')
        when 'epics'
          resource_reference.start_with?('&')
        end
      end

      def assert_epic_rule!(resource_type)
        return if resource_type != 'epics' || options.source == 'groups'

        raise EpicsTriagingForProjectImpossibleError, "Epics can only be triaged at the group level. Please set the `--source groups` option."
      end

      def resource_rules
        @resource_rules ||= policies.delete(:resource_rules) { {} }
      end

      def network_adapter
        @network_adapter ||= @network_adapter_class.new(options)
      end

      def graphql_network_adapter
        @graphql_network_adapter ||= @graphql_network_adapter_class.new(options)
      end

      def rule_conditions(rule)
        rule.fetch(:conditions) { {} }
      end

      def rule_limits(rule)
        rule.fetch(:limits) { {} }
      end

      # Process an array of +summary_definitions+.
      #
      # @example Example of an array of summary definitions (shown as YAML for readability).
      #
      #   - name: Newest and oldest issues summary
      #     rules:
      #       - name: New issues
      #         conditions:
      #           state: opened
      #         limits:
      #           most_recent: 2
      #         actions:
      #           summarize:
      #             item: "- [ ] [{{title}}]({{web_url}}) {{labels}}"
      #             summary: |
      #               Please triage the following new {{type}}:
      #               {{items}}
      #     actions:
      #       summarize:
      #         title: "Newest and oldest {{type}} summary"
      #         summary: |
      #           Please triage the following {{type}}:
      #           {{items}}
      #           Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}
      #           /label ~"needs attention"
      #
      # @param summary_definitions [Array<Hash>] An array usually given as YAML in a triage policy file.
      #
      # @return [nil]
      def process_summaries(resource_type, summary_definitions)
        return if summary_definitions.blank?

        summary_definitions.each do |summary_definition|
          process_summary(resource_type, summary_definition)
        end
      end

      # Process an array of +rule_definitions+.
      #
      # @example Example of an array of rule definitions.
      #
      #   [{ name: "New issues", conditions: { state: opened }, limits: { most_recent: 2 }, actions: { labels: ["needs attention"] } }]
      #
      # @param rule_definitions [Array<Hash>] An array usually given as YAML in a triage policy file.
      #
      # @return [nil]
      def process_rules(resource_type, rule_definitions)
        return if rule_definitions.blank?

        rule_definitions.each do |rule_definition|
          resources_for_rule(resource_type, rule_definition) do |resources|
            policy = Policies::RulePolicy.new(
              resource_type, rule_definition, resources, network)

            process_action(policy)
          end
        end
      end

      # Process a +summary_definition+.
      #
      # @example Example of a summary definition hash (shown as YAML for readability).
      #
      #   name: Newest and oldest issues summary
      #   rules:
      #     - name: New issues
      #       conditions:
      #         state: opened
      #       limits:
      #         most_recent: 2
      #       actions:
      #         summarize:
      #           item: "- [ ] [{{title}}]({{web_url}}) {{labels}}"
      #           summary: |
      #             Please triage the following new {{type}}:
      #             {{items}}
      #   actions:
      #     summarize:
      #       title: "Newest and oldest {{type}} summary"
      #       summary: |
      #         Please triage the following {{type}}:
      #         {{items}}
      #         Please take care of them before the end of #{7.days.from_now.strftime('%Y-%m-%d')}
      #         /label ~"needs attention"
      #
      # @param resource_type [String] The resource type, e.g. +issues+ or +merge_requests+.
      # @param summary_definition [Hash] A hash usually given as YAML in a triage policy file:
      #
      # @return [nil]
      def process_summary(resource_type, summary_definition)
        puts Gitlab::Triage::UI.header("Processing summary: **#{summary_definition[:name]}**", char: '~')
        puts

        summary_parts_for_rules(resource_type, summary_definition[:rules]) do |summary_resources|
          policy = Policies::SummaryPolicy.new(
            resource_type, summary_definition, summary_resources, network)

          process_action(policy)
        end
      end

      # Transform an array of +rule_definitions+ into a +PoliciesResources::SummaryResources.new(rule => rule_resources)+ object.
      #
      # @example Example of an array of rule definitions.
      #
      #   [{ name: "New issues", conditions: { state: opened }, limits: { most_recent: 2 }, actions: { labels: ["needs attention"] } }]
      #
      # @param resource_type [String] The resource type, e.g. +issues+ or +merge_requests+.
      # @param rule_definitions [Array<Hash>] An array of rule definitions, e.g.
      #                                       +[{ name: 'Foo', conditions: { milestone: 'v1' } }, { name: 'Foo', conditions: { state: 'opened' } }]+.
      #
      # @yieldparam summary_resources [PoliciesResources::SummaryResources] An object which contains a +{ rule_definition => resources }+ hash.
      # @yieldreturn [nil]
      #
      # @return [nil]
      def summary_parts_for_rules(resource_type, rule_definitions)
        # { summary_rule => resources }
        parts = rule_definitions.each_with_object({}) do |rule_definition, result|
          to_enum(:resources_for_rule, resource_type, rule_definition).each do |rule_resources, expanded_conditions|
            # We replace the non-expanded rule conditions with the expanded ones
            result.merge!(rule_definition.merge(conditions: expanded_conditions) => rule_resources)
          end

          result
        end

        yield(PoliciesResources::SummaryResources.new(parts))
      end

      # Transform a non-expanded +rule_definition+ into a +PoliciesResources::RuleResources.new(resources)+ object.
      #
      # @example Example of a rule definition hash.
      #
      #   { name: "New issues", conditions: { state: opened }, limits: { most_recent: 2 }, actions: { labels: ["needs attention"] } }
      #
      # @param resource_type [String] The resource type, e.g. +issues+ or +merge_requests+.
      # @param rule_definition [Hash] A rule definition, e.g. +{ name: 'Foo', conditions: { milestone: 'v1' } }+.
      #
      # @yieldparam rule_resources [PoliciesResources::RuleResources] An object which contains an array of resources.
      # @yieldparam expanded_conditions [Hash] A hash of expanded conditions.
      # @yieldreturn [nil]
      #
      # @return [nil]
      def resources_for_rule(resource_type, rule_definition)
        puts Gitlab::Triage::UI.header("Gathering resources for rule: **#{rule_definition[:name]}**", char: '-')

        ExpandCondition.perform(rule_conditions(rule_definition)) do |expanded_conditions|
          # retrieving the resources for every rule is inefficient
          # however, previous rules may affect those upcoming
          resources = options.resources ||
            fetch_resources(resource_type, expanded_conditions, rule_definition)

          # In some filters/actions we want to know which resource type it is
          attach_resource_type(resources, resource_type)

          puts "\n\n* Found #{resources.count} resources..."
          print "* Filtering resources..."
          resources = filter_resources(resources, expanded_conditions)
          puts "\n* Total after filtering: #{resources.count} resources"
          print "* Limiting resources..."
          resources = limit_resources(resources, rule_limits(rule_definition))
          puts "\n* Total after limiting: #{resources.count} resources"
          puts

          resources = sanitize_resources(resources)

          yield(PoliciesResources::RuleResources.new(resources), expanded_conditions)
        end
      end

      def fetch_resources(resource_type, expanded_conditions, rule_definition)
        resources = []

        if rule_definition[:api] == 'graphql'
          graphql_query_options = { source: source_full_path }

          if options.resource_reference
            expanded_conditions[:iids] = options.resource_reference[1..]
            graphql_query_options[:iids] = [expanded_conditions[:iids]]
          end

          graphql_query = build_graphql_query(resource_type, expanded_conditions, true)

          resources = graphql_network.query(graphql_query, **graphql_query_options)
        else
          # FIXME: Epics listing endpoint doesn't support filtering by `iids`, so instead we
          # get a single epic when `--resource-reference` is given for epics.
          # Because of that, the query could return a single epic, so we make sure we get an array.
          resources = Array(network.query_api(build_get_url(resource_type, expanded_conditions)))

          iids = resources.pluck('iid').map(&:to_s)
          expanded_conditions[:iids] = iids

          graphql_query = build_graphql_query(resource_type, expanded_conditions)
          graphql_resources = graphql_network.query(graphql_query, source: source_full_path, iids: iids) if graphql_query.any?

          decorate_resources_with_graphql_data(resources, graphql_resources)
        end

        resources
      end

      def attach_resource_type(resources, resource_type)
        resources.each { |resource| resource[:type] = resource_type }
      end

      def decorate_resources_with_graphql_data(resources, graphql_resources)
        return if graphql_resources.nil?

        graphql_resources_by_id = graphql_resources.index_by { |resource| resource[:id] }
        resources.each { |resource| resource.merge!(graphql_resources_by_id[resource[:id]].to_h) }
      end

      def process_action(policy)
        Action.process(
          policy: policy,
          network: network,
          dry: options.dry_run)
        puts
      end

      def filter_resources(resources, conditions)
        resources.select do |resource|
          filter_resource(resource, conditions)
        end
      end

      def filter_resource(resource, conditions)
        results = []

        FILTER_MAP.each do |condition_key, filter_value|
          # Skips to the next key value pair if the condition is not applicable
          next if conditions[condition_key].nil?

          case filter_value
          when Hash
            filter_in_ruby = conditions[condition_key].dig(:filter_in_ruby)
            merged_at = conditions[condition_key].dig(:attribute) == 'merged_at'
            filter_branch = conditions.dig(:date) && resource[:type] == 'branches'

            # Set the filter to the resource type
            if filter_in_ruby || merged_at || filter_branch
              filter = filter_value[resource[:type]]
              results << filter.new(resource, conditions[condition_key]).calculate
            end
          else
            # The `filter_value` set is not of type `hash`
            filter = filter_value

            # If the :ruby condition exists then filter based off of conditions
            # else we base off of the `conditions[condition_key]`.

            result =
              if condition_key.to_s == 'no_additional_labels'
                filter.new(resource, conditions[:labels]).calculate
              elsif condition_key.to_s == 'protected'
                filter.new(resource, conditions[:protected]).calculate
              elsif filter.instance_method(:initialize).arity == 2
                filter.new(resource, conditions[condition_key]).calculate
              else
                filter.new(resource, conditions[condition_key], network).calculate
              end

            results << result
          end
        end
        results.all?
      end

      def limit_resources(resources, limits)
        if limits.empty?
          resources
        else
          Limiters::DateFieldLimiter.new(resources, limits).limit
        end
      end

      def sanitize_resources(resources)
        resources.each do |resource|
          # Titles should not contain newlines. Translate them to spaces.
          resource[:title] = resource[:title]&.tr("\r\n", '  ')
        end
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def build_get_url(resource_type, conditions)
        # Example issues query with state and labels
        # https://gitlab.com/api/v4/projects/test-triage%2Fissue-project/issues?state=open&labels=project%20label%20with%20spaces,group_label_no_spaces
        params = {
          per_page: per_page
        }

        condition_builders = []
        condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new('iids', options.resource_reference[1..]) if options.resource_reference
        author_username = conditions[:author_username]
        condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new('author_username', author_username) if author_username

        condition_builders << APIQueryBuilders::MultiQueryParamBuilder.new('labels', conditions[:labels], ',') if conditions[:labels]

        if conditions[:forbidden_labels]
          condition_builders << APIQueryBuilders::MultiQueryParamBuilder.new('not[labels]', conditions[:forbidden_labels], ',')
        end

        if conditions[:state]
          condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new(
            'state',
            conditions[:state],
            allowed_values: ALLOWED_STATE_VALUES[resource_type])
        end

        condition_builders << milestone_condition_builder(resource_type, conditions[:milestone]) if conditions[:milestone]

        if conditions[:date] && APIQueryBuilders::DateQueryParamBuilder.applicable?(conditions[:date]) && resource_type&.to_sym != :branches
          condition_builders << APIQueryBuilders::DateQueryParamBuilder.new(conditions.delete(:date))
        end

        case resource_type&.to_sym
        when :issues
          condition_builders.concat(issues_resource_query(conditions))
        when :merge_requests
          condition_builders.concat(merge_requests_resource_query(conditions))
        when :branches
          condition_builders.concat(branches_resource_query(conditions))
        end

        condition_builders.compact.each do |condition_builder|
          params[condition_builder.param_name] = condition_builder.param_content
        end

        url_builder_options = {
          network_options: options,
          all: options.all,
          source: options.source,
          source_id: options.source_id,
          resource_type: resource_type,
          params: params
        }

        # FIXME: Epics listing endpoint doesn't support filtering by `iids`, so instead we
        # get a single epic when `--resource-reference` is given for epics.
        url_builder_options[:resource_id] = options.resource_reference[1..] if options.resource_reference && resource_type == 'epics'

        UrlBuilders::UrlBuilder.new(url_builder_options).build
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def milestone_condition_builder(resource_type, milestone_condition)
        milestone_value = Array(milestone_condition)[0].to_s # back-compatibility
        return if milestone_value.empty?

        # Issues API should use the `milestone_id` param for timebox values, and `milestone` for milestone title
        args =
          if resource_type.to_sym == :issues && MILESTONE_TIMEBOX_VALUES.include?(milestone_value.downcase)
            ['milestone_id', milestone_value.titleize] # The API only accepts titleized values.
          else
            ['milestone', milestone_value]
          end

        APIQueryBuilders::SingleQueryParamBuilder.new(*args)
      end

      def iteration_condition_builder(iteration_value)
        # Issues API should use the `iteration_id` param for timebox values, and `iteration_title` for iteration title
        args =
          if ITERATION_SELECTION_VALUES.include?(iteration_value.downcase)
            ['iteration_id', iteration_value.titleize] # The API only accepts titleized values.
          else
            ['iteration_title', iteration_value]
          end

        APIQueryBuilders::SingleQueryParamBuilder.new(*args)
      end

      def issues_resource_query(conditions)
        [].tap do |condition_builders|
          condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new('weight', conditions[:weight]) if conditions[:weight]
          condition_builders << iteration_condition_builder(conditions[:iteration]) if conditions[:iteration]
          condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new('health_status', conditions[:health_status]) if conditions[:health_status]
          condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new('issue_type', conditions[:issue_type]) if conditions[:issue_type]
        end
      end

      def merge_requests_resource_query(conditions)
        [].tap do |condition_builders|
          [
            :source_branch,
            :target_branch,
            :reviewer_id
          ].each do |key|
            condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new(key.to_s, conditions[key]) if conditions[key]
          end
          condition_builders << draft_condition_builder(conditions[:draft]) if conditions.key?(:draft)
        end
      end

      def branches_resource_query(conditions)
        [].tap do |condition_builders|
          condition_builders << APIQueryBuilders::SingleQueryParamBuilder.new('search', conditions[:name]) if conditions[:name]
        end
      end

      def draft_condition_builder(draft_condittion)
        # Issues API only accepts 'yes' and 'no' as strings: https://docs.gitlab.com/ee/api/merge_requests.html
        wip =
          case draft_condittion
          when true
            'yes'
          when false
            'no'
          else
            raise ArgumentError, 'The "draft" condition only accepts true or false.'
          end

        APIQueryBuilders::SingleQueryParamBuilder.new('wip', wip)
      end

      def build_graphql_query(resource_type, conditions, graphql_only = false)
        Gitlab::Triage::GraphqlQueries::QueryBuilder
          .new(options.source, resource_type, conditions, graphql_only: graphql_only)
      end

      def source_full_path
        @source_full_path ||= fetch_source_full_path
      end

      def fetch_source_full_path
        return options.source_id unless /\A\d+\z/.match?(options.source_id)

        source_details = network.query_api(build_get_url(nil, {})).first
        full_path = source_details['full_path'] || source_details['path_with_namespace']

        raise ArgumentError, 'A source with given source_id was not found!' if full_path.blank?

        full_path
      end
    end
  end
end
