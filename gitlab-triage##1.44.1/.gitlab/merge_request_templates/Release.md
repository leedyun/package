<!-- Replace `<PREVIOUS_VERSION>` with the previous version number here, `<COMMIT_UPDATING_VERSION>` with the latest
commit from this merge request, and `<NEW_VERSION>` with the upcoming version number. -->
## Diff

https://gitlab.com/gitlab-org/ruby/gems/gitlab-triage/-/compare/<PREVIOUS_VERSION>...<COMMIT_UPDATING_VERSION>

## Checklist

- [ ] Diff link is up-to-date.
- [ ] Check the release notes: https://gitlab.com/api/v4/projects/3430480/repository/changelog?version=<NEW_VERSION>
- [ ] Based on the diff and the release notes, `version.rb` is updated, according to [SemVer](https://semver.org).

/label ~"type::maintenance" ~"maintenance::workflow" ~"ep::triage"
