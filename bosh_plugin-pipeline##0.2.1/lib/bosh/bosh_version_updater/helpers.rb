require 'git'

module Bosh
  module BoshVersionUpdater
    module Helpers

      def run_tests?
        !options[:without_tests]
      end

      def make_commit?
        !options[:without_commit]
      end

      def make_push?
        !options[:without_commit]
      end

      def find_gemspec_file(plugin_path)
        gemspec_file = Dir[File.join(plugin_path, "*.gemspec")].first
        if gemspec_file.nil?
          say "Can't find gemspec file in #{plugin_path}.".make_yellow
          say "[ERROR] The folder doesn't seem to contain a gem.".make_red
          exit(2)
        end
        gemspec_file
      end

      def update_bosh_gem_version_in_gemspec(gemspec_file)
        say "Using #{gemspec_file} gemspec file to update BOSH version"

        current_bosh_version = bosh_gem_latest_version
        bosh_version_regex = /bosh_version\s*=\s*['"]((\d+\.)?(\d+\.)?(\*|\d+))['"]/
        gemspec_file_text = File.read(gemspec_file)
        old_bosh_version_match = gemspec_file_text.match(bosh_version_regex)

        if old_bosh_version_match.nil?
          say "Can't find BOSH version if gemspec.".make_yellow
          say "We expected your gemspec file contains 'bosh_version = \"<some-version>\" string.".make_yellow
          say "[ERROR] Can't find BOSH version.".make_red
          exit(2)        
        end

        old_bosh_version = old_bosh_version_match.to_a[1]
        if old_bosh_version == current_bosh_version
          say "Everything is uptodate."
          exit(0)
        end

        say "Changing BOSH version from #{old_bosh_version} to #{current_bosh_version}"
        gemspec_file_text.gsub!(bosh_version_regex, "bosh_version = '#{current_bosh_version}'")
        File.open(gemspec_file, 'w') { |file| file.write(gemspec_file_text) }

        say "gemspec file is updated."
      end

      def run_bundle_install(plugin_path)
        Dir.chdir(plugin_path) do
          Bundler.with_clean_env do
            system('bundle install')
            unless ($?.success?)
              say "`bundle install` failed.".make_red
              exit(2)
            end
          end
        end
      end

      def run_tests(plugin_path)
        Dir.chdir(plugin_path) do
          Bundler.with_clean_env do
            say "Running tests"
            system('bundle exec rake')
            unless ($?.success?)
              say "Tests failed.".make_red
              exit(2)
            end
          end
        end
      end

      def make_commit(plugin_path)
        say '#make_commit is not implemented yet'
      end

      def make_push(plugin_path)
        say '#make_commit is not implemented yet'
      end

    end
  end
end
