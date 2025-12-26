require "bosh/bosh_version_updater"

module Bosh::Cli::Command
  class BoshVersionUpdater < Base
    include Bosh::BoshVersionUpdater::Helpers
    include Bosh::Versions::Helpers

    # example: bosh generate plugin bosh-magic
    usage "update-bosh-version"
    desc "Updates plugin's BOSH version, runs tests and makes commit, " + 
         "takes as parameter path to plugin, by default uses current folder"
    option "--without-tests", "Don't run tests before commit"
    option "--without-commit", "Don't do commit after update"
    option "--without-push", "Don't push updated gem to github and rubygems"
    def update_bosh_version(plugin_path = Dir.pwd)
      gemspec_file = find_gemspec_file(plugin_path)
      update_bosh_gem_version_in_gemspec(gemspec_file)
      run_bundle_install(plugin_path)
      run_tests(plugin_path) if run_tests?
      if make_commit?
        make_commit(plugin_path)
        make_push(plugin_path) if make_push?
      end
    end

  end
end
