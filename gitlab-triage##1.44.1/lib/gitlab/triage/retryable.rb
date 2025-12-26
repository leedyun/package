# frozen_string_literal: true

module Gitlab
  module Triage
    module Retryable
      MAX_RETRIES = 3
      RETRY_WAIT_SECONDS = 10
      BACK_OFF_SECONDS = 10

      attr_accessor :tries

      def execute_with_retry(exception_types: [StandardError], backoff_exceptions: [], debug: false)
        @tries = 0

        until maximum_retries_reached?
          begin
            @tries += 1
            return yield
          rescue *exception_types => e
            base_message = "exception - %s, waiting #{RETRY_WAIT_SECONDS} secs)"

            if maximum_retries_reached?
              puts_execute_with_retry_message(e, format(base_message, "gave up, tried #{MAX_RETRIES} times")) if debug
              raise
            else
              puts_execute_with_retry_message(e, format(base_message, "retrying #{@tries}/#{MAX_RETRIES} times")) if debug
              sleep(RETRY_WAIT_SECONDS)
            end
          rescue *backoff_exceptions => e
            base_message = "backoff - %s, waiting #{BACK_OFF_SECONDS} secs)"

            if maximum_retries_reached?
              puts_execute_with_retry_message(e, format(base_message, "gave up, tried #{MAX_RETRIES} times")) if debug
              raise
            else
              puts_execute_with_retry_message(e, format(base_message, "retrying #{@tries}/#{MAX_RETRIES} times")) if debug
              sleep(BACK_OFF_SECONDS)
            end
          end
        end
      end

      private

      def maximum_retries_reached?
        tries == MAX_RETRIES
      end

      def puts_execute_with_retry_message(exception, message)
        puts Gitlab::Triage::UI.debug "execute_with_retry: #{exception} (#{message}"
      end
    end
  end
end
