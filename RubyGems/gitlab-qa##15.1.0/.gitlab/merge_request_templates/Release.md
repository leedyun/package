<!-- Replace `<PREVIOUS_VERSION>` with the previous version number here, `<COMMIT_UPDATING_VERSION>` with the latest
commit from this merge request, and `<NEW_VERSION>` with the upcoming version number. -->
## Diff

https://gitlab.com/gitlab-org/gitlab-qa/-/compare/<PREVIOUS_VERSION>...<COMMIT_UPDATING_VERSION>

## Pre-merge checklist

- [ ] Diff link is up-to-date.
- [ ] Check the release notes: https://gitlab.com/api/v4/projects/gitlab-org%2Fgitlab-qa/repository/changelog?version=<NEW_VERSION>
- [ ] Based on the diff and the release notes, `version.rb` is updated, according to [SemVer](https://semver.org).

## Post-merge checklist

- [ ] In the `pipeline-common` project, [update the GITLAB_QA_VERSION](https://gitlab.com/gitlab-org/quality/pipeline-common/-/blob/master/ci/base.gitlab-ci.yml) (make sure to add a `Changelog:` trailer to the commit) and [create a release](https://gitlab.com/gitlab-org/quality/pipeline-common#release-process).
- [ ] Unless already done by [`renovate-gitlab-bot`](https://gitlab.com/dashboard/merge_requests?scope=all&state=opened&author_username=gitlab-dependency-update-bot&label_name[]=Engineering%20Productivity), in the GitLab project, update the ref for `pipeline-common` in [`.gitlab/ci/qa-common/main.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/.gitlab/ci/qa-common/main.gitlab-ci.yml).
- [ ] Unless already done by [`renovate-gitlab-bot`](https://gitlab.com/dashboard/merge_requests?scope=all&state=opened&author_username=gitlab-dependency-update-bot&label_name[]=Quality), or if you need it sooner, in the GitLab project, update the `gitlab-qa` gem version in [`qa/Gemfile`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/qa/Gemfile) and [`qa/Gemfile.lock`](https://gitlab.com/gitlab-org/gitlab/-/blob/master/qa/Gemfile.lock) (for an example, see: https://gitlab.com/gitlab-org/gitlab/-/merge_requests/117054).

/label ~Quality ~"type::maintenance" ~"maintenance::dependency" ~Quality
