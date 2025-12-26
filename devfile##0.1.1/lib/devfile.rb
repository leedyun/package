# frozen_string_literal: true

require 'open3'

# Module that works with the Devfile standard
module Devfile
  class CliError < StandardError; end

  # Set of services to parse a devfile and output k8s manifests
  class Parser
    FILE_PATH = File.expand_path('./../bin/devfile', File.dirname(__FILE__))
    DEVFILE_GEMSPEC = Gem.loaded_specs['devfile']
    SYSTEM_PLATFORM = "#{Gem::Platform.local.cpu}-#{Gem::Platform.local.os}"

    class << self
      def get_deployment(devfile, name, namespace, labels, annotations, replicas)
        call('deployment', devfile, name, namespace, labels, annotations, replicas)
      end

      def get_service(devfile, name, namespace, labels, annotations)
        call('service', devfile, name, namespace, labels, annotations)
      end

      def get_ingress(devfile, name, namespace, labels, annotations, domain_template, ingress_class)
        call('ingress', devfile, name, namespace, labels, annotations, domain_template, ingress_class)
      end

      def get_pvc(devfile, name, namespace, labels, annotations)
        call('deployment', devfile, name, namespace, labels, annotations)
      end

      def get_all(devfile, name, namespace, labels, annotations, replicas, domain_template, ingress_class)
        call('all', devfile, name, namespace, labels, annotations, replicas, domain_template, ingress_class)
      end

      def flatten(devfile)
        call('flatten', devfile)
      end

      private

      def call(*cmd)
        warn_for_ruby_platform

        stdout, stderr, status = Open3.capture3({}, FILE_PATH, *cmd.map(&:to_s))

        raise(CliError, stderr) unless status.success?

        stdout
      end

      def warn_for_ruby_platform
        return unless DEVFILE_GEMSPEC && DEVFILE_GEMSPEC.platform == 'ruby' && SYSTEM_PLATFORM != 'arm64-darwin'

        warn "devfile-gem only supports os: darwin and architecture: arm64 for 'ruby' platform"
      end
    end
  end
end
