# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module GitlabClient
      class BranchesDryClient < BranchesClient
        def create(branch_name, ref)
          branch = { 'name' => branch_name, 'web_url' => 'https://example.com/dummy/branch/url' }
          puts "A branch would have been created with name: #{branch['name']}, web_url: #{branch['web_url']} and ref: #{ref}"
          branch
        end
      end
    end
  end
end
