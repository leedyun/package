# frozen_string_literal: true

require 'active_support/core_ext/enumerable'

module GitlabQuality
  module TestTooling
    module Report
      module Concerns
        module ResultsReporter
          include Concerns::Utils

          TEST_CASE_RESULTS_SECTION_TEMPLATE = "\n\n### DO NOT EDIT BELOW THIS LINE\n\nActive and historical test results:"

          def find_issue(test)
            issues = search_for_issues(test)

            warn(%(Too many #{issue_type}s found with the file path "#{test.file}" and name "#{test.name}")) if issues.many?

            puts "Found existing #{issue_type}: #{issues.first.web_url}" unless issues.empty?

            issues.first
          end

          def find_issue_by_iid(iid)
            issues = gitlab.find_issues(iid: iid) do |issue|
              issue.state == 'opened' && issue.issue_type == issue_type
            end

            warn(%(#{issue_type} iid "#{iid}" not valid)) if issues.empty?

            issues.first
          end

          def issue_title_needs_updating?(issue, test)
            issue.title.strip != title_from_test(test) && !%w[canary production preprod release].include?(pipeline)
          end

          def new_issue_labels(_test)
            %w[Quality status::automated]
          end

          def up_to_date_labels(test:, issue: nil, new_labels: Set.new)
            labels = super
            labels |= new_issue_labels(test).to_set
            labels.delete_if { |label| label.start_with?("#{pipeline}::") }
            labels << (test.failures.empty? ? "#{pipeline}::passed" : "#{pipeline}::failed")
          end

          def update_issue(issue, test)
            update_params = {}

            old_title = issue.title.strip
            new_title = title_from_test(test)

            if old_title != new_title
              update_params[:title] = new_title
              warn(%(#{issue_type} title needs to be updated from '#{old_title}' to '#{new_title}'))
            end

            old_description = issue.description
            new_description = updated_description(issue, test)

            if old_description != new_description
              warn(%(#{issue_type} description needs to be updated from '#{old_description}' to '#{new_description}'))
              update_params[:description] = new_description
            end

            return if update_params.empty?

            gitlab.edit_issue(iid: issue.iid, options: update_params)
          end

          private

          def search_term(test)
            %("#{partial_file_path(test.file)}" "#{search_safe(test.name)}")
          end

          def search_for_issues(test)
            gitlab.find_issues(options: { search: search_term(test) }) do |issue|
              issue.state == 'opened' && issue.issue_type == issue_type && issue.title.strip == title_from_test(test)
            end
          end
        end
      end
    end
  end
end
