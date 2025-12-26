# License Mode Omnibus Configuration

This configuration is used to set the License Mode in GitLab to test.

When GitLab's License Mode is set to test, GitLab will not enforce License Key encryption to activate an instance
with an Enterprise License

## What happens?

GitLab-QA will set the environment variable `GITLAB_LICENSE_MODE=test` and set the `CUSTOMER_PORTAL_URL=<URL>` where URL
is `ENV['CUSTOMER_PORTAL_URL']` or CDot Staging (`https://customers.staging.gitlab.com`).
