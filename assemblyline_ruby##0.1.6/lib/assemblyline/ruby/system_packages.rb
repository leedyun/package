require "json"
require "bundler"

module Assemblyline
  module Ruby
    class SystemPackages
      def initialize(data = nil)
        @data = data
      end

      def any?
        all.any?
      end

      def all
        build + runtime
      end

      def build
        buildeps = dependencies("build")
        buildeps += ["git"] if needs_git?
        buildeps
      end

      def runtime
        dependencies("runtime")
      end

      private

      def needs_git?
        lockfile.sources.any? { |source| source.is_a? Bundler::Source::Git }
      end

      def dependencies(context)
        deps.map { |dep| dep[context] }.flatten.uniq.compact.sort
      end

      def deps
        packages.map do |pkg|
          data.select do |dep|
            pkg == dep["name"]
          end
        end.flatten
      end

      def packages
        lockfile.specs.map(&:name)
      end

      def lockfile
        @_lockfile ||= Bundler::LockfileParser.new(File.read("Gemfile.lock"))
      end


      def data
        @data ||= JSON.parse(File.read("/etc/assemblyline/dependencies.json"))
      end
    end
  end
end
