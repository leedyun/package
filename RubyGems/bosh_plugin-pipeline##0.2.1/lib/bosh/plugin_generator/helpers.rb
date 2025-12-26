require 'git'
require 'bosh/versions'

module Bosh
  module PluginGenerator
    module Helpers

      attr_accessor :plugin_name, :plugin_folder, :lib_folder, :helpers_folder,
                    :commands_folder, :bosh_version

      extend Forwardable
      include Bosh::Versions::Helpers
      def_delegator :@generator, :generate

      def extract_options(plugin_name)
        @plugin_name     = plugin_name
        @plugin_folder   = plugin_name
        @bosh_version    = bosh_gem_latest_version
        @license_type    = options[:license]
        @lib_folder      = File.join(plugin_name, 'lib', 'bosh')
        @spec_folder     = File.join(plugin_name, 'spec')
        @helpers_folder  = File.join(lib_folder, short_plugin_name)
        @commands_folder = File.join(lib_folder, 'cli', 'commands')

        default_context = {
          email: Git.global_config["user.email"],
          author: Git.global_config["user.name"],
          description: "Short description.",
          license: nil,
          full_plugin_name: full_plugin_name,
          short_plugin_name: short_plugin_name,
          class_name: short_plugin_name.split('_').collect(&:capitalize).join,
          bosh_version: bosh_version
        }
        context = default_context.merge(options)
        raise "You need to specify email and author" if context[:email].nil? || context[:author].nil?
        templates_folder = File.expand_path("../../../../templates", __FILE__)
        @generator = Bosh::TemplateGenerator::Generator.new(context, source_folder: templates_folder)
      end
      
      def generate_files
        generate_command_class
        generate_helpers
        generate_version
        generate_gemspec
        generate_readme
        generate_license if license?
        generate_developer_environment
      end

      private

      def full_plugin_name
        return @full_plugin_name if @full_plugin_name
        separator = plugin_name.include?('_') ? '_' : '-'
        @full_plugin_name = plugin_name.start_with?('bosh') ? plugin_name : ['bosh', plugin_name].join(separator)
      end

      def short_plugin_name
        @short_plugin_name ||= plugin_name.gsub(/^bosh[_-]/, '')
      end

      def license?
        !!@license_type
      end

      def generate_command_class
        generate('main.rb.erb', File.join(lib_folder, "#{short_plugin_name}.rb"))
        generate('cli/commands/command.rb.erb', File.join(commands_folder, "#{short_plugin_name}.rb"))
      end

      def generate_helpers
        generate('helpers_folder/helpers.rb.erb', File.join(helpers_folder, 'helpers.rb'))
      end

      def generate_version
        generate('helpers_folder/version.rb.erb', File.join(helpers_folder, 'version.rb'))
      end

      def generate_gemspec
        generate('gemspec.erb', File.join(plugin_name, "#{full_plugin_name}.gemspec"))
      end

      def generate_readme
        generate('README.md.erb', File.join(plugin_name, 'README.md'))
      end

      def generate_license
        generate("licenses/#{@license_type}.txt", File.join(plugin_name, 'LICENSE'))
      end

      def generate_developer_environment
        generate('Gemfile', File.join(plugin_folder, 'Gemfile'))
        generate('Rakefile', File.join(plugin_folder, 'Rakefile'))
        generate('spec/spec_helper.rb', File.join(@spec_folder, 'spec_helper.rb'))
        generate('spec/command_spec.rb', File.join(@spec_folder, 'command_spec.rb'))
        generate('spec/.rspec', File.join(plugin_folder, '.rspec'))
        generate('.gitignore', File.join(plugin_folder, '.gitignore'))
        generate('.ruby-version.erb', File.join(plugin_folder, '.ruby-version'))
        generate('.ruby-gemset.erb', File.join(plugin_folder, '.ruby-gemset'))
        generate('.travis.yml', File.join(plugin_folder, '.travis.yml'))
      end

    end
  end
end
