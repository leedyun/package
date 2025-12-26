# frozen_string_literal: true

require 'rainbow/refinement'
require 'zeitwerk'

module Gitlab
  module QA
    loader = Zeitwerk::Loader.new
    loader.push_dir("#{__dir__}/qa", namespace: Gitlab::QA)
    loader.ignore("#{__dir__}/qa/version.rb")

    loader.inflector.inflect(
      'postgresql' => 'PostgreSQL',
      'registry_with_cdn' => 'RegistryWithCDN',
      'smtp' => 'SMTP',
      'mtls' => 'MTLS',
      'saml' => 'SAML',
      'ce' => 'CE',
      'ee' => 'EE',
      'api' => 'API',
      'ssh' => 'SSH',
      'ssh_key' => 'SSHKey',
      'ssh_keys' => 'SSHKeys',
      'ecdsa' => 'ECDSA',
      'ed25519' => 'ED25519',
      'rsa' => 'RSA',
      'ldap' => 'LDAP',
      'ldap_tls' => 'LDAPTLS',
      'ldap_no_tls' => 'LDAPNoTLS',
      'ldap_no_server' => 'LDAPNoServer',
      'rspec' => 'RSpec',
      'web_ide' => 'WebIDE',
      'ci_cd' => 'CiCd',
      'project_imported_from_url' => 'ProjectImportedFromURL',
      'repo_by_url' => 'RepoByURL',
      'oauth' => 'OAuth',
      'saml_sso_sign_in' => 'SamlSSOSignIn',
      'saml_sso_sign_up' => 'SamlSSOSignUp',
      'group_saml' => 'GroupSAML',
      'instance_saml' => 'InstanceSAML',
      'saml_sso' => 'SamlSSO',
      'ldap_sync' => 'LDAPSync',
      'ip_address' => 'IPAddress',
      'gpg' => 'GPG',
      'user_gpg' => 'UserGPG',
      'otp' => 'OTP',
      'jira_api' => 'JiraAPI',
      'registry_tls' => 'RegistryTLS',
      'jetbrains' => 'JetBrains',
      'vscode' => 'VSCode',
      'cli_commands' => 'CLICommands',
      'import_with_smtp' => 'ImportWithSMTP'
    )

    loader.setup
  end
end
