# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module SharedFields
        module Meta
          def meta_fields
            [
              :meta_user,
              :meta_project,
              :meta_caller_id
            ]
          end
        end

        module Exception
          def exception_fields
            [
              :exception_class,
              :exception_message,
              :exception_backtrace
            ]
          end
        end
      end
    end
  end
end
