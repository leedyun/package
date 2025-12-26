# frozen_string_literal: true

module Gitlab
  module Triage
    class UI
      def self.header(text, char: '=')
        header = char * text.size

        [header, text, header, nil].join("\n")
      end

      def self.debug(text)
        "[DEBUG] #{text}"
      end

      def self.warn(text)
        "[WARNING] #{text}"
      end

      def self.error(text)
        "[ERROR] #{text}"
      end
    end
  end
end
