# frozen_string_literal: true

require_relative "../patcher"

require_relative "example"
require_relative "example_group"
require_relative "runner"

module Datadog
  module CI
    module Contrib
      module RSpec
        # Patcher enables patching of 'rspec' module.
        module Patcher
          include Datadog::CI::Contrib::Patcher

          module_function

          def patch
            ::RSpec::Core::Runner.include(Runner)
            ::RSpec::Core::Example.include(Example)
            ::RSpec::Core::ExampleGroup.include(ExampleGroup)
          end
        end
      end
    end
  end
end
