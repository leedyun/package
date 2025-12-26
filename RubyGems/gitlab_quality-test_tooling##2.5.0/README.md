# `GitlabQuality::TestTooling`

This gem provides test tooling that can be used by different projects or different part of the same project, mostly in CI scripts.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlab_quality-test_tooling', require: false
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install gitlab_quality-test_tooling
```

## Usage

The gem provides the following executables.

### `exe/generate-test-session`

```shell
Purpose: Generate test session report based on RSpec report files (JSON or JUnit XML)
Usage: exe/generate-test-session [options]
    -i, --input-files INPUT_FILES    RSpec report files (JSON or JUnit XML)
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Reporter permission in PROJECT
    -c CI_PROJECT_TOKEN,             A valid access token with `read_api` scope permission in current ENV["CI_PROJECT_ID"]
        --ci-project-token
    -f ISSUE_URL_FILE,               Output the created test session issue URL
        --issue-url-file
        --confidential               Makes test session issue confidential
        --dry-run                    Perform a dry-run (don't create or update issues or test cases)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/post-to-slack`

```shell
Purpose: Post a message to Slack, and optionally add a test summary table based on RSpec report files (JUnit XML)
Usage: exe/post-to-slack [options]
    -w SLACK_WEBHOOK_URL,            Slack webhook URL
        --slack-webhook-url
    -c, --channel CHANNEL            Slack channel to post the message to
    -m, --message MESSAGE            Post message to Slack
    -t FILES,                        Add a test summary table based on RSpec report files (JUnit XML)
        --include-summary-table
    -u, --username USERNAME          Username to use for the Slack message
    -i, --icon-emoji ICON_EMOJI      Icon emoji to use for the Slack message
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/prepare-stage-reports`

```shell
Purpose: Prepare separate reports for each DevOps stage from the provided RSpec report files (JUnit XML)
Usage: exe/prepare-stage-reports [options]
    -i, --input-files INPUT_FILES    RSpec report files (JUnit XML)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/relate-failure-issue`

```shell
Purpose: Relate test failures to failure issues from RSpec report files (JSON or JUnit XML)
Usage: exe/relate-failure-issue [options]
    -i, --input-files INPUT_FILES    RSpec report files (JSON or JUnit XML)
    -m METRICS_FILES,                Test metrics files (JSON)
        --metrics-files
        --max-diff-ratio MAX_DIFF_RATO
                                     Max stacktrace diff ratio for failure issues detection
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
    -r RELATED_ISSUES_FILE,          The file path for the related issues
        --related-issues-file
        --system-log-files SYSTEM_LOG_FILES
                                     Include errors from system logs in failure issues
        --base-issue-labels BASE_ISSUE_LABELS
                                     Labels to add to new failure issues
        --exclude-labels-for-search EXCLUDE_LABELS_FOR_SEARCH
                                     Labels to exclude when searching for existing issues
        --confidential               Makes created new issues confidential
        --dry-run                    Perform a dry-run (don't create or update issues)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/report-results`

```shell
Purpose: Report test results from RSpec report files (JSON or JUnit XML) in GitLab test cases and result issues
Usage: exe/report-results [options]
    -i, --input-files INPUT_FILES    RSpec report files (JSON or JUnit XML)
        --test-case-project TEST_CASE_PROJECT
                                     Can be an integer or a group/project string
    -t TEST_CASE_PROJECT_TOKEN,      A valid access token with `api` scope and Reporter permission in TEST_CASE_PROJECT
        --test-case-project-token
        --results-issue-project RESULTS_ISSUE_PROJECT
                                     Can be an integer or a group/project string
    -r RESULTS_ISSUE_PROJECT_TOKEN,  A valid access token with `api` scope and Reporter permission in RESULTS_ISSUE_PROJECT
        --results-issue-project-token
        --dry-run                    Perform a dry-run (don't create/update issues or test cases)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/update-screenshot-paths`

```shell
Purpose: Update the path to screenshots to container's host from RSpec report files (JSON or JUnit XML)
Usage: exe/update-screenshot-paths [options]
    -i, --input-files INPUT_FILES    RSpec report files (JSON or JUnit XML)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/slow-test-issues`

```shell
Purpose: Create slow test issues from JSON RSpec report files
Usage: exe/slow-test-issues [options]
    -i, --input-files INPUT_FILES    JSON RSpec report files JSON
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
    -r RELATED_ISSUES_FILE,          The file path for the related issues
        --related-issues-file
        --dry-run                    Perform a dry-run (don't create issues)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/knapsack-report-issues`

```shell
Purpose: Create spec run time issue when a spec file almost caused job timeout because it ran significantly longer than what Knapsack expected.
Usage: exe/knapsack-report-issues [options]
    -i, --input-file INPUT_FILE      Knapsack actual run time report file path glob
    -e EXPECTED_REPORT,              Knapsack expected report file path
        --expected-report
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
        --dry-run                    Perform a dry-run (don't create issues)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/failed-test-issues`

```shell
Purpose: Relate test failures to failure issues from RSpec report files (JSON or JUnit XML)
Usage: exe/failed-test-issues [options]
    -i, --input-files INPUT_FILES    RSpec report files (JSON or JUnit XML)
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
        --max-diff-ratio MAX_DIFF_RATO
                                     Max stacktrace diff ratio for failure issues detection
    -r RELATED_ISSUES_FILE,          The file path for the related issues
        --related-issues-file
        --base-issue-labels BASE_ISSUE_LABELS
                                     Labels to add to new failure issues
        --exclude-labels-for-search EXCLUDE_LABELS_FOR_SEARCH
                                     Labels to exclude when searching for existing issues
        --dry-run                    Perform a dry-run (don't create or update issues)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/existing-test-health-issue`

```shell
Purpose: Checks whether tests coming from the rspec JSON report files has an existing test health issue opened.
Usage: exe/existing-test-health-issue [options]
    -i, --input-files INPUT_FILES    JSON rspec-retry report files
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
        --health-problem-type PROBLEM_TYPE
                                     Look for the given health problem type (failures, pass-after-retry, slow)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/detect-infrastructure-failures`

```shell
Purpose: Checks wether a job failed on a known infrastructure error by parsing its trace.
Usage: exe/detect-infrastructure-failures [options]
   -j, --job-id JOB_ID              A valid Job ID
   -p, --project PROJECT            Can be an integer or a group/project string
   -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
```

### `exe/flaky-test-issues`

```shell
Purpose: Create flaky test issues for any passed test coming from rspec-retry JSON report files.
Usage: exe/flaky-test-issues [options]
    -i, --input-files INPUT_FILES    JSON rspec-retry report files
    -p, --project PROJECT            Can be an integer or a group/project string
    -m MERGE_REQUEST_IID,            An integer merge request IID
        --merge_request_iid
        --base-issue-labels BASE_ISSUE_LABELS
                                     Comma-separated labels (without tilde) to add to new flaky test issues
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
        --dry-run                    Perform a dry-run (don't create issues)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/slow-test-merge-request-report-note`

```shell
Purpose: Create slow test note on merge requests from JSON RSpec report files
Usage: exe/slow-test-merge-request-report-note [options]
    -i, --input-files INPUT_FILES    JSON RSpec report files JSON
    -p, --project PROJECT            Can be an integer or a group/project string
    -m MERGE_REQUEST_IID,            An integer merge request IID
        --merge_request_iid
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
        --dry-run                    Perform a dry-run (don't create note)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

### `exe/update-test-meta`

```shell
Purpose: Add quarantine or reliable meta to specs
Usage: exe/update-test-meta [options]
    -u INPUT_FILES,                  File with list of unstable specs (JSON) to quarantine
        --unstable-specs-file
    -s INPUT_FILES,                  File with list of stable specs (JSON) to add :reliable meta
        --stable-specs-file
    -p, --project PROJECT            Can be an integer or a group/project string
    -t, --token TOKEN                A valid access token with `api` scope and Maintainer permission in PROJECT
        --dry-run                    Perform a dry-run (don't create branches, commits or MRs)
    -v, --version                    Show the version
    -h, --help                       Show the usage
```

## Development

### Initial setup

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Activate lefthook locally

```shell
lefthook install
```

### Testing unreleased changes in merge requests

To test an unreleased change in an actual merge request, you can create a merge request that will install the unreleased version of `gitlab_quality-test_tooling`. Bundler can install gems by specifying a repository and a revision from Git.

For example, to test `gitlab_quality-test_tooling` changes from the `your-branch-name` branch in [`gitlab-org/gitlab`](https://gitlab.com/gitlab-org/gitlab), in the `Gemfile`:

```ruby
group :development, :test, :danger do
  gem 'gitlab_quality-test_tooling', '~> 3.4.3', require: false,
  git: 'https://gitlab.com/gitlab-org/ruby/gems/gitlab_quality-test_tooling.git',
  ref: 'your-branch-name'
end
```

See an [example](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/92580) for more details.

## Release

[Automated gem release process](https://gitlab.com/gitlab-org/quality/pipeline-common#release-process) is used to release new version of `gitlab_quality-test_tooling` through pipelines, and this will:

- Publish the gem: https://rubygems.org/gems/gitlab_quality-test_tooling
- Add a release in the `gitlab_quality-test_tooling` project: https://gitlab.com/gitlab-org/ruby/gems/gitlab_quality-test_tooling/-/releases
- Populate the release log with the API contents. For example: https://gitlab.com/api/v4/projects/19861191/repository/changelog?version=3.4.4

### Before release

Make sure to include a changelog entry in your commit message and read the [changelog entries section](https://docs.gitlab.com/ee/development/changelog.html).

If you forget to set the changelog entry in your commit messages, you can also edit the release notes after it's being released.

### Steps to release

Use a `Release` merge request template and create a merge request to update the version number in `version.rb`, and get the merge request merged by a maintainer.

This will then be packaged into a gem and pushed to [rubygems.org](https://rubygems.org) by the CI/CD.

For example: [Bump version to 3.4.3](https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles/-/merge_requests/149).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GitlabQuality::TestTooling project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://gitlab.com/gitlab-org/ruby/gems/gitlab_quality-test_tooling/-/blob/main/CODE_OF_CONDUCT.md).
