# frozen_string_literal: true

require_relative "../../gitlab/dangerfiles/approval"
require_relative "../../gitlab/dangerfiles/spinner"
require_relative "../../gitlab/dangerfiles/teammate"

module Danger
  # Common helper functions for our danger scripts. See Danger::Helper
  # for more details
  class Roulette < Danger::Plugin
    HOURS_WHEN_PERSON_CAN_BE_PICKED = (6..14).freeze
    HTTPError = Class.new(StandardError)

    def prepare_categories(changes_keys)
      categories = Set.new(changes_keys)

      # Ensure to spin for database reviewer/maintainer when ~database is applied (e.g. to review SQL queries)
      categories << :database if labels.include?("database")

      # Ensure to spin for Analytics Instrumentation reviewer when ~"analytics instrumentation::review pending" is applied
      categories << :analytics_instrumentation if labels.include?("analytics instrumentation::review pending")

      # Skip Analytics Instrumentation reviews for growth experiment MRs
      categories.delete(:analytics_instrumentation) if labels.include?("growth experiment")

      prepare_ux_category!(categories) if labels.include?("UX")

      # Remove disabled categories
      categories.subtract(helper.config.disabled_roulette_categories)

      categories
    end

    # Finds the +Gitlab::Dangerfiles::Teammate+ object whose username matches the MR author username.
    #
    # @return [Gitlab::Dangerfiles::Teammate]
    def team_mr_author
      @team_mr_author ||= Gitlab::Dangerfiles::Teammate.find_member(helper.mr_author)
    end

    # Assigns GitLab team members to be reviewer and maintainer
    # for the given +categories+.
    #
    # @param project [String] A project path.
    # @param categories [Array<Symbol>] An array of categories symbols.
    #
    # @return [Array<Spin>]
    def spin(project = nil, categories = [:none], ux_fallback_wider_community_reviewer: teammate_pedroms)
      # TODO: Deprecate the project argument. It prevents us from
      # memorizing Spinner and can cause unexpected results if it's
      # passing a different project than the merge request project.
      project = (project || config_project_name).downcase
      categories = categories.map { |category| category&.downcase || :none }

      Gitlab::Dangerfiles::Spinner.new(
        project: project,
        author: helper.mr_author, team_author: team_mr_author,
        labels: labels, categories: categories, random: random,
        ux_fallback_wider_community_reviewer:
          ux_fallback_wider_community_reviewer)
        .spin
    end

    def codeowners_approvals
      approval_rules = helper.mr_approval_state["rules"]

      return [] unless approval_rules

      required_approval_rules = unique_approval_rules(approval_rules)
      required_approval_rules.filter_map do |rule|
        if spin_for_approval_rule?(rule)
          approver = Gitlab::Dangerfiles::Spinner.new(
            project: config_project_name.downcase,
            author: helper.mr_author, team_author: team_mr_author,
            random: random
          ).spin_for_approver(rule)

          Gitlab::Dangerfiles::Approval.from_approval_rule(rule, approver)
        end
      end
    end

    alias_method :required_approvals, :codeowners_approvals

    # For backward compatibility
    def warnings
      Gitlab::Dangerfiles::Teammate.warnings
    end

    private

    def teammate_pedroms
      @teammate_pedroms ||= Gitlab::Dangerfiles::Teammate.find_member("pedroms")
    end

    def spin_for_approval_rule?(rule)
      rule["rule_type"] == "code_owner" &&
        should_include_codeowners_rule?(rule) &&
        # Exclude generic codeowners rule, which should be covered by others already
        !generic_codeowners_rule?(rule) &&
        !excluded_required_codeowners_rule?(rule)
    end

    def should_include_codeowners_rule?(rule)
      rule["approvals_required"] > 0 ||
        helper.config.included_optional_codeowners_sections_for_roulette.include?(rule["section"])
    end

    def excluded_required_codeowners_rule?(rule)
      helper.config.excluded_required_codeowners_sections_for_roulette.include?(rule["section"])
    end

    def generic_codeowners_rule?(rule)
      rule["section"] == "codeowners" && rule["name"] == "*"
    end

    # Returns an array containing all unique approval rules, based on on the section and eligible_approvers of the rules
    #
    # @param [Array<Hash>] approval rules
    # @return [Array<Hash>]
    def unique_approval_rules(approval_rules)
      approval_rules.uniq do |rule|
        section = rule["section"]

        approvers = rule["eligible_approvers"].map do |approver|
          approver["username"]
        end

        [section, approvers]
      end
    end

    def random
      @random ||= Random.new(Digest::MD5.hexdigest(helper.mr_source_branch).to_i(16))
    end

    def prepare_ux_category!(categories)
      if labels.include?("Community contribution") ||
          # We only want to spin a reviewer for merge requests which has a
          # designer for the team.
          Gitlab::Dangerfiles::Teammate.has_member_for_the_group?(
            :ux, project: config_project_name.downcase, labels: labels)
        categories << :ux
      end
    end

    # Return the configured project name
    #
    # @return [String]
    def config_project_name
      helper.config.project_name
    end

    # Return the labels from the merge requests. This is cached.
    #
    # @return [String]
    def labels
      @labels ||= helper.mr_labels
    end
  end
end
