[![Gem Version](https://badge.fury.io/rb/gitlab-qa.svg)](https://rubygems.org/gems/gitlab-qa)
[![build status](https://gitlab.com/gitlab-org/gitlab-qa/badges/master/pipeline.svg)](https://gitlab.com/gitlab-org/gitlab-qa/pipelines)
[![coverage report](https://gitlab.com/gitlab-org/gitlab-qa/badges/master/coverage.svg)](https://gitlab.com/gitlab-org/gitlab-qa/-/commits/master)

# GitLab QA orchestrator

## Definitions

- **GitLab QA framework**: A framework that allows developers to write end-to-end
  tests simply and efficiently.
  Located at [`gitlab-org/gitlab-foss@qa/qa/`][qa-framework].
- **GitLab QA instance-level scenarios**: RSpec scenarios that use the
  GitLab QA framework and Capybara to setup and perform individual end-to-end
  tests against a live GitLab instance.
  Located at [`gitlab-org/gitlab-foss@qa/qa/specs/features/`][instance-level-scenarios].
- **GitLab QA orchestrator** (this project): An orchestration tool that enables
  running various QA test suites in a simple manner.
- **GitLab QA orchestrated scenarios**: Scenarios where containers are started,
  configured, and execute instance-level scenarios against a running GitLab
  instance.
  Located at [`gitlab-org/gitlab-qa@lib/gitlab/qa/scenario/test/`][orchestrated-scenarios].

[qa-framework]: https://gitlab.com/gitlab-org/gitlab-foss/blob/master/qa/qa/
[instance-level-scenarios]: https://gitlab.com/gitlab-org/gitlab-foss/blob/master/qa/qa/specs/features/
[orchestrated-scenarios]: https://gitlab.com/gitlab-org/gitlab-qa/blob/master/lib/gitlab/qa/scenario/test/

## Goals and objectives

GitLab consists of multiple pieces configured and packaged by
[GitLab Omnibus](https://gitlab.com/gitlab-org/omnibus-gitlab).

The purpose of the QA end-to-end test suite is to verify that all pieces
integrate well together.

### Testing changes in merge requests before the merge

The ultimate goal is to make it possible to run the QA test suite for any
merge request, even before merging code into the `master` branch.

### We can run tests against any instance of GitLab

GitLab QA is a click-driven, black-box testing tool. We also use it to run
tests against the staging environment, and we strive to make it useful for our
users as well.

### GitLab QA tests running in the CI/CD environment

Manual steps should not be needed to run the QA test suite.
GitLab QA orchestrator is CI/CD environment native, which means that we should
add new features and tests when we are comfortable with running new code in the
CI/CD environment.

### GitLab QA test failures are reproducible locally

Despite the fact that GitLab QA orchestrator has been built to run in the CI/CD
environment, it is really important to make it easy for developers to reproduce
test failures locally. It is much easier to debug things locally, than in the
CI/CD environment.

To make it easier to reproduce test failures locally we have published the
`gitlab-qa` gem [on rubygems.org](https://rubygems.org/gems/gitlab-qa) and we
are using exactly the same approach to run tests in the CI/CD environment.

It means that using the `gitlab-qa` CLI tool, which orchestrates the test
environment and runs the GitLab QA test suite, is a reproducible way of running
tests locally and in the CI/CD environment.

It also means that we cannot have custom code in `.gitlab-ci.yml` to, for
example, start new containers / services.

### Test the installation / deployment process too

We distribute GitLab in a package (like a Debian package or a Docker image) so
we want to test the installation process to ensure that our package is not
broken.

But we are also working on making GitLab be a cloud native product. This means
that, for example, using Helm becomes yet another installation / deployment
process that we want to test with GitLab QA.

Considering our goal of being able to test all changes in merge requests, it is
especially important to be able to test our Kubernetes deployments, as that is
essential to scaling our test environments to efficiently handle a large number
of tests.

## Documentation

- [Architecture](docs/architecture.md)
- [How it works](docs/how_it_works.md)
- [Release process](docs/release_process.md)
- [Run QA tests against your GDK setup](docs/run_qa_against_gdk.md)
- [Trainings](docs/trainings.md)
- [Waits](docs/waits.md)
- [What tests can be run?](docs/what_tests_can_be_run.md)
- [Specifics for Mac OS with M1, M2 processors & Docker Desktop](docs/specifics_for_macos_m1_m2.md)

## How do we use it

Currently, we execute the test suite against GitLab Docker images created by
Omnibus nightly via a [`gitlab-org/gitlab` nightly schedule pipeline](https://gitlab.com/gitlab-org/gitlab/-/pipeline_schedules).

We also execute the test suite nightly against our [staging environment](https://staging.gitlab.com)
via a pipeline in the [staging project](https://gitlab.com/gitlab-org/quality/staging).

Finally, we trigger GitLab QA pipelines whenever someone clicks `package-and-qa` manual
action in a merge request.

## How can you use it

The GitLab QA tool is published as a [Ruby Gem](https://rubygems.org/gems/gitlab-qa).

You can install it with `gem install gitlab-qa`. It will expose a `gitlab-qa`
command in your system.

If you want to run the scenarios against your GDK and/or develop them on Mac OS,
please read [Run QA tests against your GDK setup](/docs/run_qa_against_gdk.md)
as there are caveats and things that may work differently.

All the scenarios you can run are described in the
[What tests can be run?](/docs/what_tests_can_be_run.md) documentation.

Note: The GitLab QA tool requires that [Docker](https://docs.docker.com/install/) is installed.


### Command-line options

In addition to the [arguments you can use to specify the scenario and
tests to run](/docs/what_tests_can_be_run.md), you can use the
following options to control the tool's behavior.

**Note:** These are `gitlab-qa` options so if you specify RSpec
options as well, including test file paths, be sure to add these
options before the `--` that indicates that subsequent arguments are
intended for RSpec.

| Option | Description |
| ------ | ----------- |
| `--no-teardown` | Skip teardown of containers after the scenario completes |
| `--no-tests` | Orchestrates the docker containers but does not run the tests. Implies `--no-teardown` |

For example, the following command would start an EE GitLab Docker
container and would leave the instance running, but would not run the
tests:

```plaintext
$ gitlab-qa Test::Instance::Image EE --no-tests
```

GitLab QA will have automatically run the `docker ps` command to show
the port that container is running on, for example:

```plaintext
...
Skipping tests.
The orchestrated docker containers have not been removed.
Docker shell command: `docker ps`
CONTAINER ID  IMAGE                     ... PORTS
fdeffd791b69  gitlab/gitlab-ee:nightly      22/tcp, 443/tcp, 0.0.0.0:32768->80/tcp
```

You could then run tests against that instance in a similar way to
[running tests against GDK](/docs/run_qa_against_gdk.md). This can be
useful if you want to run and debug a specific test, for example:

```plaintext
# From /path/to/gdk/gitlab/qa
$ bundle exec bin/qa Test::Instance::All http://localhost:32768 -- qa/specs/features/browser_ui/3_create/merge_request/create_merge_request_spec.rb
```

### Lefthook

[Lefthook](https://github.com/evilmartians/lefthook) is a Git hooks manager that allows
custom logic to be executed prior to Git committing or pushing. This project comes with
Lefthook configuration checked in (`lefthook.yml`), but it must be installed.

#### Install Lefthook

   ```shell
   # Install the `lefthook` Ruby gem:
   bundle install
   # Initialize the lefthook config and adds to .git/hooks dir
   bundle exec lefthook install
   # Verify hook execution works as expected
   bundle exec lefthook run pre-push
   ```

For a detailed guide on `lefthook` configuration see https://github.com/evilmartians/lefthook/blob/master/docs/configuration.md

### How to add new tests

Please see the [Beginner's guide to writing end-to-end tests](https://docs.gitlab.com/ee/development/testing_guide/end_to_end/beginners_guide.html).

Test cases and scripts to run them are located in the
[GitLab FOSS](https://gitlab.com/gitlab-org/gitlab-foss/tree/master/qa) and
[GitLab](https://gitlab.com/gitlab-org/gitlab/tree/master/qa)
repositories under the `qa/` directory, so please also check the documentation
there.

## Contributing

Please see the [contribution guidelines](CONTRIBUTING.md).
