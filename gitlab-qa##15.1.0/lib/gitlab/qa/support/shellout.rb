# frozen_string_literal: true

module Gitlab
  module QA
    module Support
      module Shellout
        module_function

        def shell(command = nil, stdin_data: nil, mask_secrets: nil, stream_output: false, &block)
          Support::ShellCommand.new(
            command, stdin_data: stdin_data, mask_secrets: mask_secrets, stream_output: stream_output).execute!(&block)
        end
      end
    end
  end
end
