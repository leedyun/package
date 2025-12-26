# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module TestResults
      class BaseTestResults
        include Enumerable

        attr_reader :path

        def initialize(path:, token: nil, project: nil, ref: 'master')
          @path = path
          @token = token
          @project = project
          @ref = ref
          @results = parse
          @testcases = process
        end

        def each(&block)
          testcases.each(&block)
        end

        def write
          raise NotImplementedError
        end

        private

        attr_reader :results, :testcases, :token, :project, :ref

        def parse
          raise NotImplementedError
        end

        def process
          raise NotImplementedError
        end
      end
    end
  end
end
