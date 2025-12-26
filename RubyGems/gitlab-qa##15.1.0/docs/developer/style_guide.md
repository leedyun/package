# Style Guide

## RuboCop rule development guide

Our codebase style is defined and enforced by [RuboCop](https://github.com/rubocop/rubocop).

You can check for any offenses locally with `bundle exec rubocop --parallel`.
On the CI, this is automatically checked by the `rubocop` jobs in the `check` stage.

### Lefthook

[Lefthook](https://github.com/evilmartians/lefthook) is a Git hooks manager that allows
custom logic to be executed prior to Git committing or pushing. GitLab comes with
Lefthook configuration (`lefthook.yml`), but it must be installed.

We have a `lefthook.yml` checked in but it is ignored until Lefthook is installed.

### Install Lefthook

   ```shell
   # Install the `lefthook` Ruby gem:
   bundle install
   # Initialize the lefthook config and adds to .git/hooks dir
   bundle exec lefthook install
   # Verify hook execution works as expected
   bundle exec lefthook run pre-push
   ```

For a detailed guide on left hook configuration see <https://github.com/evilmartians/lefthook/blob/master/docs/configuration.md>
