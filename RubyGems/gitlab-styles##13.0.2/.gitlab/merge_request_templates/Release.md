<!-- Replace `<PREVIOUS_VERSION>` with the previous version number, `<COMMIT_UPDATING_VERSION>` with the latest
commit from this merge request, and `<NEW_VERSION>` with the upcoming version number. -->
## Diff

https://gitlab.com/gitlab-org/ruby/gems/gitlab-styles/-/compare/<PREVIOUS_VERSION>...<COMMIT_UPDATING_VERSION>

<!--

NOTE:
If you are working with a fork use: https://gitlab.com/<YOUR_NAMESPACE>/gitlab-styles/-/compare/<PREVIOUS_VERSION>...<COMMIT_UPDATING_VERSION>?from_project_id=4176070

-->

## Checklist

- [ ] Change the `VERSION` constant to a minor version in  `lib/gitlab/styles/version.rb` (you might have to change the version number in the next steps according to [SemVer](https://semver.org)).
- [ ] Ensure the diff link above is up-to-date.
- [ ] Add release notes to the [Changelog](#changelog) section below.
- [ ] Based on the diff and the release notes, update the `version.rb` according to [SemVer](https://semver.org).
- [ ] Run `bundle install` to update `Gemfile.lock`
- [ ] Create an MR on `gitlab-org/gitlab` project [with the `New Version of gitlab-styles.md` template](https://gitlab.com/gitlab-org/gitlab/-/blob/master/.gitlab/merge_request_templates/New%20Version%20of%20gitlab-styles.md) to test the new version of `gitlab-styles`, and follow the MR instructions.

## Changelog

<!--
Paste output of:

curl https://gitlab.com/api/v4/projects/4176070/repository/changelog?version=<NEW_VERSION> | jq -r ".notes"

NOTE:
Emphasize changes via `**BREAKING CHANGE**` or `**IMPORTANT**` etc. if actions are required by users
Example: https://gitlab.com/gitlab-org/ruby/gems/gitlab-styles/-/releases/13.0.0

-->

/label ~"type::maintenance" ~"static code analysis"
