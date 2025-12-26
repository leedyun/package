# frozen_string_literal: true

require 'amatch'

module GitlabQuality
  module TestTooling
    class StackTraceComparator
      include Amatch

      def initialize(first_trace, second_trace)
        @first_trace = first_trace
        @second_trace = second_trace
      end

      def diff_ratio
        @diff_ratio ||= (1 - first_trace.levenshtein_similar(second_trace))
      end

      def diff_percent
        (diff_ratio * 100).round(2)
      end

      def lower_than_diff_ratio?(max_diff_ratio)
        diff_ratio < max_diff_ratio
      end

      def lower_or_equal_to_diff_ratio?(max_diff_ratio)
        diff_ratio <= max_diff_ratio
      end

      private

      attr_reader :first_trace, :second_trace
    end
  end
end
