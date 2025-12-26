# TestFileFinder

A Ruby gem for detecting test files associated with input files.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'test_file_finder', git: 'https://gitlab.com/gitlab-org/ci-cd/test_file_finder.git'
```

And then execute:

```shell
bundle install
```

## Usage

### Ruby

The FileFinder class has exactly one method (`#test_files`) that returns existing test files likely to be associated with the files you passed into `#initialize`:

```ruby
TestFileFinder::FileFinder.new(paths: file_paths).test_files
```

### Command Line

TestFileFinder is packed up into the `tff` executable, which can be used from the command line:

```bash
$ file_paths="app/models/widget.rb"
$ tff $file_paths
spec/models/widget_spec.rb
```

You can use it in a script, for example:

```bash
$ rspec $(tff $(git diff --name-only master..head))
```

#### Options

##### `-f mapping`

`TestFileFinder` can be used with an optional YAML mapping file to specify the mapping from a `source` file to a `test` file. Both, `source` and `test` can be lists to map multiple files.

The mapping file is a yaml file containing to entries to match source file patterns to its test files.

The source file pattern may be an exact file path or a regular expression. The regular expression may include capturing groups to be used to identify the test file. To refer to a captured value in the test file, use the `%s` placeholder. For example:

```yaml
mapping:
  # maps `app/file.rb` to `spec/file_spec.rb`
  - source: 'app/(.+)\.rb'
    test: 'spec/%s_spec.rb'
  # maps `db/schema.rb` and `db/migrate/*` to `spec/db/schema_spec.rb`
  - source:
      - 'db/schema.rb'
      - 'db/migrate/(.+)'
    test: spec/db/schema_spec.rb
  # maps `ee/app/models/ee/user.rb` to `ee/spec/models/user_spec.rb` and `spec/models/user_spec.rb`
  - source: ee/app/(.*/)ee/(.+)\.rb
    test:
      - 'spec/%s%s_spec.rb'
      - 'ee/spec/%s%s_spec.rb'
```

The patterns may include named captures in test files and referenced by its
name in source files. For example:

```yaml
mapping:
  # maps `lib/api/issues.rb` to `spec/requests/api/issues/issues_spec.rb`
  - source: 'lib/api/(?<name>.*)\.rb'
    test: 'spec/requests/api/%{name}/%{name}_spec.rb'
```

Numbered and named captures cannot be mixed in a single pattern.

A test file containing metacharacters like `*`, `{}`, `[]`, or `?` is
considered a file name pattern and [globbing is used to match](https://rubyapi.org/o/dir#method-c-glob)
the resulting test files.

For example:

```yaml
mapping:
  # maps `lib/api/issues.rb` to tests following this pattern
  # `spec/requests/api/issues/*_spec.rb`
  - source: 'lib/api/(.*)\.rb'
    test: 'spec/requests/api/%s/*_spec.rb'
```

Command line example:

```bash
$ file_paths="app/models/widget.rb"
$ tff -f mapping.yml $file_paths
spec/models/widget_spec.rb
```

Ruby example:

```ruby
tff = TestFileFinder::FileFinder.new(paths: file_paths)
tff.use TestFileFinder::MappingStrategies::PatternMatching.load('mapping.yml')
tff.test_files
```

An example mapping file is available in `fixtures/mapping.yml`.

##### `--json mapping`

`TestFileFinder` can be used with an optional JSON mapping file to specify the mapping from a source file to test files.

The mapping file is a JSON file containing a JSON object. The keys in the JSON are the source files, and the values are
arrays containing the test files. For example:

```json
{
  "app/models/project.rb": [
    "spec/models/project_spec.rb",
    "spec/controllers/projects_controller_spec.rb"
  ],
  "app/controllers/projects_controller.rb": [
    "spec/controllers/projects_controller_spec.rb"
  ]
}
```

Command line example:

```bash
$ file_paths="app/models/project.rb"
$ tff --json mapping.json $file_paths
spec/models/project_spec.rb
spec/controllers/projects_controller_spec.rb
```

Ruby example:

```ruby
tff = TestFileFinder::FileFinder.new(paths: file_paths)
tff.use TestFileFinder::MappingStrategies::DirectMatching.load('mapping.json')
tff.test_files
```

An example mapping file is available in `fixtures/mapping.json`.

It's also possible to **return a percentage of test files** with the `limit_percentage` and `limit_min` arguments (only available in ruby):

```ruby
tff = TestFileFinder::FileFinder.new(paths: file_paths)
# Return 50% of the test files, with a minimum of 14 test files.
tff.use TestFileFinder::MappingStrategies::DirectMatching.load('mapping.json', limit_percentage: 50, limit_min: 14)
tff.test_files
```

##### `--project-path project_path` and `--merge-request-iid merge_request_iid`

`TestFileFinder` can be used with both GitLab project path and merge request IID to get the test files that failed in the project merge request.

Command line example:

```bash
$ tff --project-path project/path --merge-request-iid 123
spec/models/widget_spec.rb
```

Ruby example:

```ruby
tff = TestFileFinder::FileFinder.new(paths: file_paths)
tff.use TestFileFinder::MappingStrategies::GitlabMergeRequestRspecFailure.new(project_path: 'project/path', merge_request_iid: 123)
tff.test_files
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Activate lefthook locally

```shell
lefthook install
```

## Release Process

We release `test_file_finder` on an ad-hoc basis. There is no regularity to when
we release, we just release when we make a change - no matter the size of the
change.

To release a new version:

1. Create a Merge Request.
1. Use Merge Request template [Release.md](https://gitlab.com/gitlab-org/ruby/gems/test_file_finder/-/blob/master/.gitlab/merge_request_templates/Release.md).
1. Follow the instructions.
1. After the Merge Request has been merged, a new gem version is [published automatically](https://gitlab.com/gitlab-org/components/gem-release).

See [!49](https://gitlab.com/gitlab-org/ruby/gems/test_file_finder/-/merge_requests/49) as an example.

## Contributing

Bug reports and merge requests are welcome in GitLab at <https://gitlab.com/gitlab-org/ci-cd/test_file_finder>.
