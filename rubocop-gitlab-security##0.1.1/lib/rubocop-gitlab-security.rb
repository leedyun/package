require 'pathname'
require 'yaml'

require 'rubocop'

require 'rubocop/gitlab-security'
require 'rubocop/gitlab-security/version'
require 'rubocop/gitlab-security/inject'
require 'rubocop/gitlab-security/top_level_describe'
require 'rubocop/gitlab-security/wording'
require 'rubocop/gitlab-security/util'
require 'rubocop/gitlab-security/language'
require 'rubocop/gitlab-security/language/node_pattern'
require 'rubocop/gitlab-security/concept'
require 'rubocop/gitlab-security/example_group'
require 'rubocop/gitlab-security/example'
require 'rubocop/gitlab-security/hook'
require 'rubocop/cop/gitlab-security/cop'

RuboCop::GitlabSecurity::Inject.defaults!

require 'rubocop/cop/gitlab-security/deep_munge'
require 'rubocop/cop/gitlab-security/json_serialization'
require 'rubocop/cop/gitlab-security/public_send'
require 'rubocop/cop/gitlab-security/redirect_to_params_update'
require 'rubocop/cop/gitlab-security/send_file_params'
require 'rubocop/cop/gitlab-security/sql_injection'
require 'rubocop/cop/gitlab-security/system_command_injection'
