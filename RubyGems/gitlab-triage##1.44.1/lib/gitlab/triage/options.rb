# frozen_string_literal: true

module Gitlab
  module Triage
    Options = Struct.new(
      :dry_run,
      :policies_files,
      :resources,
      :all,
      :source,
      :source_id,
      :resource_reference,
      :token,
      :debug,
      :host_url,
      :require_files,
      :api_version
    ) do
      def initialize(*args)
        super

        # Defaults
        self.host_url ||= 'https://gitlab.com'
        self.api_version ||= 'v4'
        self.all ||= false
        self.source ||= 'projects'
        self.require_files ||= []
        self.policies_files ||= Set.new
      end
    end
  end
end
