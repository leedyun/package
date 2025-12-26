<!-- Replace `<PREVIOUS_VERSION>` with the previous version number, `<COMMIT_UPDATING_VERSION>` with the latest
commit from this merge request, and `<NEW_VERSION>` with the upcoming version number. -->
## Diff

https://gitlab.com/gitlab-org/ruby/gems/test_file_finder/-/compare/<PREVIOUS_VERSION>...<COMMIT_UPDATING_VERSION>

## Checklist

- [ ] Run `bundle install` locally to update the `Gemfile.lock` file
- [ ] Ensure the diff link above is up-to-date.
- [ ] Add release notes to the [Changelog](#changelog) section below.
- [ ] Based on the diff and the release notes, update the `version.rb` according to [SemVer](https://semver.org).

## Changelog

<!--
Paste output of:

curl https://gitlab.com/api/v4/projects/gitlab-org%2Fruby%2Fgems%2Ftest_file_finder/repository/changelog?version=<NEW_VERSION> | jq -r ".notes"

NOTE: Skip `v` in `<NEW_VERSION>`. For example, Use `version=0.3.0` instead of `version=v0.3.0`.

-->

/label ~"type::maintenance" ~"maintenance::dependency" 
