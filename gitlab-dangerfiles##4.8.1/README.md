# Gitlab::Dangerfiles

The goal of this gem is to centralize Danger plugins and rules that to be used by multiple GitLab projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gitlab-dangerfiles', require: false
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install gitlab-dangerfiles
```

## Usage

### Importing plugins and rules

In your project's `Dangerfile`, add the following to import the plugins and rules from this gem:

```ruby
require 'gitlab-dangerfiles'

Gitlab::Dangerfiles.for_project(self) do |dangerfiles|
  # Import all plugins from the gem
  dangerfiles.import_plugins

  # Import all rules from the gem
  dangerfiles.import_dangerfiles

  # Or import only a subset of rules
  dangerfiles.import_dangerfiles(only: %w[changes_size])

  # Or import all rules except a subset of rules
  dangerfiles.import_dangerfiles(except: %w[commit_messages])

  # Or import only a subset of rules, except a subset of rules
  dangerfiles.import_dangerfiles(only: %w[changes_size], except: %w[commit_messages])
end
```

For simple projects such as libraries, you can use the convenience method `import_defaults`:

```ruby
Gitlab::Dangerfiles.for_project(self) do |dangerfiles|
  # Imports all plugins, rules and the default reviewer roulette
  dangerfiles.import_defaults
end
```

You may optionally pass a project name; by default, `ENV['CI_PROJECT_NAME']` will be used:

```ruby
Gitlab::Dangerfiles.for_project(self, 'my-project') do |dangerfiles|
  # Imports all plugins, rules and the default reviewer roulette
  dangerfiles.import_defaults
end
```

Note that your custom plugins and rules (unless you exclude them with `except`) are automatically imported by the gem.

### Import and load order

Plugins are imported in alphabetical order. Gem plugins are loaded before
project-local plugins.

Gem and project-local rules are combined, filtered, and loaded in alphabetical order.

Because all rules are executed as soon as they are imported, you should move all
logic from your root `Dangerfile` to project-local rules in
`danger/*/Dangerfile`.

For example:

**Bad**

`Dangerfile`:

```ruby
Gitlab::Dangerfiles.for_project(self) do |dangerfiles|
  dangerfiles.import_dangerfiles(only: %w[z_add_labels])
end

# Bad, because gem rule `z_add_labels` has already been executed with empty labels list.
helper.labels_to_add << 'important'
```

**Good**

`Dangerfile`:

```ruby
Gitlab::Dangerfiles.for_project(self) do |dangerfiles|
  dangerfiles.import_dangerfiles(only: %w[z_add_labels])
end
```

`danger/labels/Dangerfile`:

```ruby
# Good. Execution order:
# * root `Dangerfile`
# * project-local `danger/my_labels/Dangerfile`
# * gem rule `danger/z_add_labels/Dangerfile`
helper.labels_to_add << 'important'
```

### Plugins

Danger plugins are located under `lib/danger/plugins`.

- `Danger::Helper` available in `Dangerfile`s as `helper`
- `Danger::Changelog` available in `Dangerfile`s as `changelog`
- `Danger::Roulette` available in `Dangerfile`s as `roulette`

For the full documentation about the plugins, please see https://www.rubydoc.info/gems/gitlab-dangerfiles.

### Configuration

Default configuration can be overriden in the form `helper.config.CONFIG_NAME = NEW_VALUE` (`CONFIG_NAME` being a value configuration key).

Alternatively, you can also get/set configuration on the engine directly via `Gitlab::Dangerfiles::Engine#config`.

#### Available general configurations

- `project_root`: The project root path. You shouldn't have to override it.
- `project_name`: The project name. Currently used by the Roulette plugin to fetch relevant
  reviewers/maintainers based on the project name. Default to `ENV["CI_PROJECT_NAME"]`.
- `ci_only_rules`: A list of rules that cannot run locally.
- `files_to_category`: A hash of the form `{ filename_regex => categories, [filename_regex, changes_regex] => categories }`.
  `filename_regex` is the regex pattern to match file names. `changes_regex` is the regex pattern to
  match changed lines in files that match `filename_regex`. Used in `helper.changes_by_category`, `helper.changes`, and `helper.categories_for_file`.
- `disabled_roulette_categories`: A list of categories that roulette can be disabled. In the projects where specific review workflows are not ready, this can be used to disable them.

### Rules

Danger rules are located under `lib/danger/rules`.

#### `changelog`

This rule ensures the merge request follows our [Changelog guidelines](https://docs.gitlab.com/ee/development/changelog.html#changelog-entries).

#### `changes_size`

This rule ensures the merge request isn't too big to be reviewed, otherwise it suggests to split the MR.

##### Available configurations

- `code_size_thresholds`: A hash of the form `{ high: 42, medium: 12 }` where
  `:high` is the lines changed threshold which triggers an error, and
  `:medium` is the lines changed threshold which triggers a warning.

#### `commit_messages`

##### Available configurations

- `max_commits_count`: The maximum number of allowed non-squashed/non-fixup commits for a given MR.
   A warning is triggered if the MR has more commits.

#### `commits_counter`

This rule posts a failure if the merge request has more than 20 commits.

#### `metadata`

This rule ensures basic metadata such as assignee, milestone and description are set on the merge request.

#### `simple_roulette`

The library includes a simplified default reviewer roulette that you can use in your
project. To use it in your project, perform the following steps:

1. If not yet done, create a `Dangerfile` at the top-level of your project. Refer to [Usage](#usage) to
   see how to set it up.
1. When using the default roulette, use `import_defaults` or import it manually when setting
   up the gitlab-dangerfiles instance:

   ```ruby
   require 'gitlab-dangerfiles'

   Gitlab::Dangerfiles.for_project(self) do |dangerfiles|
     dangerfiles.import_plugins
     dangerfiles.import_dangerfiles(only: %w[simple_roulette])
   end
   ```

#### `type_label`

If the `changelog` plugin is available, it tries to infer a type label from the `Changelog` trailer of the MR.

#### `z_add_labels`

This rule adds labels set from other rules (via `helper.labels_to_add`), with a single API request.

#### `z_retry_link`

This rule adds a retry link to the job where Danger ran at the end of the Danger message, only if there's any other message to post.

### CI configuration

In order to run `danger` on GitLab CI, perform the following steps:

1. If not yet done, create a `Dangerfile` at the top-level of your project. Refer to [Usage](#usage) to
   see how to set it up.
2. In `.gitlab-ci.yml`, include [CI configuration](https://gitlab.com/gitlab-org/quality/pipeline-common/-/blob/master/ci/danger-review.yml)
   which defines `danger-review` [CI job](https://docs.gitlab.com/ee/ci/jobs/):

```yaml
include:
  - project: 'gitlab-org/quality/pipeline-common'
    file:
      - '/ci/danger-review.yml'
```

3. Create a [Project or group access token](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html)
   with scope `api` and role `Developer`.
4. Add a [CI/CD variable](https://docs.gitlab.com/ee/ci/variables/#add-a-cicd-variable-to-a-project)
   `DANGER_GITLAB_API_TOKEN` (`Masked` but not `Protected`) and use Project access token as value.

See a [real world example](https://gitlab.com/gitlab-org/ruby/gems/gitlab-styles/-/merge_requests/105).

#### Without `Gemfile`

Danger is a Ruby project and uses [`bundler`](https://bundler.io/) to manage
its dependencies. This requires a project to have a `Gemfile` and
`Gemfile.lock` commited. This is helpful especially if Danger is also used
locally - with `lefthook`, for example.

In order to skip Ruby and `bundler` dependency in a project, use `bundle` commands directly
in the CI configuration:

```yaml
include:
  - project: 'gitlab-org/quality/pipeline-common'
    file: '/ci/danger-review.yml'

danger-review:
  before_script:
    - bundle init
    # For latest version
    - bundle add gitlab-dangerfiles
    # OR
    # For a pinned version
    - bundle add gitlab-dangerfiles --version 3.1.0
```

## Local Danger Rake task

You can run a Danger Rake task locally in a project to detect Danger errors before pushing commits to a remote
branch.

1. [Install `gitlab-dangerfiles`](#installation) in your project.
1. Add the following to your project's `Rakefile`:

   ```ruby
   require 'gitlab-dangerfiles'

   Gitlab::Dangerfiles.load_tasks
   ```

To run the Danger Rake task in a project that has `master` as the default branch, run:

```shell
bundle exec rake danger_local
```

To run the Danger Rake task in a project that doesn't have `master` as the default branch, you must set the
`DANGER_LOCAL_BASE` environment variable. For example, in a project with `main` as the default branch:

```shell
DANGER_LOCAL_BASE="origin/main" bundle exec rake danger_local
```

## Documentation

Latest documentation can be found at <https://www.rubydoc.info/gems/gitlab-dangerfiles>.

## Development

### Initial setup

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Activate lefthook locally

```shell
lefthook install
```

### Testing unreleased changes in merge requests

To test an unreleased change in an actual merge request, you can create a merge request that will install the unreleased version of `gitlab-dangerfiles`. Bundler can install gems by specifying a repository and a revision from Git.

For example, to test `gitlab-dangerfiles` changes from the `your-branch-name` branch in [`gitlab-org/gitlab`](https://gitlab.com/gitlab-org/gitlab), in the `Gemfile`:

```ruby
group :development, :test, :danger do
  gem 'gitlab-dangerfiles', '~> 3.4.3', require: false,
  git: 'https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles.git',
  ref: 'your-branch-name'
end
```

See an [example](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/92580) for more details.

## Contributing

Bug reports and merge requests are welcome at https://gitlab.com/gitlab-org/gitlab-dangerfiles. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://gitlab.com/gitlab-org/gitlab-dangerfiles/blob/master/CODE_OF_CONDUCT.md).

Make sure to include a changelog entry in your commit message and read the [changelog entries section](https://docs.gitlab.com/ee/development/changelog.html).

## Release

[Automated gem release process](https://gitlab.com/gitlab-org/quality/pipeline-common#release-process) is used to release new version of `gitlab-dangerfiles` through [pipelines](https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles/-/blob/4f33cf30cab84f7e27ca0cb9a7c0da3ecc675c11/.gitlab-ci.yml#L51), and this will:

- Publish the gem: https://rubygems.org/gems/gitlab-dangerfiles
- Add a release in the `gitlab-dangerfiles` project: https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles/-/releases
- Populate the release log with the API contents. For example: https://gitlab.com/api/v4/projects/19861191/repository/changelog?version=3.4.4

We follow this release process in a separate merge request from the one that introduced the changes. The release merge request should just contain a version bump.

### Before release

Changes merged since the last release should have had changelog entries (see [Contributing](#contributing)).

If changelog entries are missing, you can also edit the release notes after it's being released.

### Steps to release

Use a `Release` merge request template and create a merge request to update the version number in `version.rb`, and get the merge request merged by a maintainer.

This will then be packaged into a gem and pushed to [rubygems.org](https://rubygems.org) by the CI/CD.

For example: [Bump version to 3.4.3](https://gitlab.com/gitlab-org/ruby/gems/gitlab-dangerfiles/-/merge_requests/149).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gitlab::Danger project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://gitlab.com/gitlab-org/gitlab-dangerfiles/blob/master/CODE_OF_CONDUCT.md).
