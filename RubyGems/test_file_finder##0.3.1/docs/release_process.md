# Release Process

## Versioning

We follow [Semantic Versioning](https://semver.org).  In short, this means that the new version should reflect the types of changes that are about to be released.

*summary from semver.org*

MAJOR.MINOR.PATCH

- MAJOR version when you make incompatible API changes,
- MINOR version when you add functionality in a backwards compatible manner, and
- PATCH version when you make backwards compatible bug fixes.

## When we release

We release `gitlab-triage` on an ad-hoc basis.  There is no regularity to when we release, we just release
when we make a change - no matter the size of the change.

## How-to

- Check if there is an [open merge request to bump the version](https://gitlab.com/gitlab-org/ci-cd/test_file_finder/merge_requests?scope=all&utf8=%E2%9C%93&state=opened&search=bump+version) (to avoid creating a duplicate).
  - If there is one, update it if necessary.
  - If not, update [`lib/test_file_finder/version.rb`] to an appropriate [semantic version](https://semver.org) in a new merge request using the [release template](https://gitlab.com/gitlab-org/ci-cd/test_file_finder/blob/master/.gitlab/merge_request_templates/Release.md)
    and title the MR like `"Bump version to <version>"`.
- Merge the merge request.
- The new version should automatically be tagged and pushed to Rubygems by the `release` job in the merge commit pipeline.
- Update the release notes for the newly created tag (https://gitlab.com/gitlab-org/ci-cd/test_file_finder/-/tags):
  * **Release notes**: Copy the release notes from the merge request.

Note: The `bundle exec release` command uses the `GEM_HOST_API_KEY` environment variable to authenticate against the
`rubygems.org`.

[`lib/test_file_finder/version.rb`]: https://gitlab.com/gitlab-org/ci-cd/test_file_finder/blob/master/lib/test_file_finder/version.rb#L2
