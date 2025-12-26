export CI_PROJECT_ID=10947578
export CI_API_V4_URL="https://gitlab.com/api/v4"
export CI_PROJECT_URL="https://gitlab.com/gitlab-org/ruby/gems/labkit-ruby"
# Don't keep secrets in plaintext files. Use a keyring or 1password to load
# it instead and export it as an env var.
token=$(load-your-token)
export GITLAB_TOKEN=$token
