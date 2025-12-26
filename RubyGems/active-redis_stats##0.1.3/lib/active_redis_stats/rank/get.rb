# frozen_string_literal: true

module ActiveRedisStats
  module Rank
    class Get < ActiveRedisStats::Rank::Base

      LIMIT ||= 100

      class << self
        def all(key, with_scores: false)
          ActiveRedisDB::SortedSet
            .evaluate
            .all_reverse(primary_key(key), with_scores: with_scores) || []
        end

        def all_intervals(key, with_scores: false, format: :month, offset: 0)
          ikey = send("#{format}_key", offset: offset)
          all("#{key}:#{ikey}", with_scores: with_scores)
        end

        def between(key, with_scores: false, from:, to:)
          ActiveRedisDB::SortedSet
            .evaluate
            .between_reverse(primary_key(key), from, to, with_scores: with_scores) || []
        end

        # rubocop:disable Metrics/ParameterLists
        def between_intervals(key, with_scores: false, from:, to:, format: :month, offset: 0)
          ikey = send("#{format}_key", offset: offset)
          between("#{key}:#{ikey}", with_scores: with_scores, from: from, to: to)
        end
        # rubocop:enable Metrics/ParameterLists

        def bottom(key, with_scores: false, limit: LIMIT)
          ActiveRedisDB::SortedSet
            .evaluate
            .between(primary_key(key), 1, limit, with_scores: with_scores) || []
        end

        def bottom_intervals(key, with_scores: false, limit: LIMIT, format: :month, offset: 0)
          ikey = send("#{format}_key", offset: offset)
          bottom("#{key}:#{ikey}", with_scores: with_scores, limit: limit)
        end

        def top(key, with_scores: false, limit: LIMIT)
          ActiveRedisDB::SortedSet
            .evaluate
            .between_reverse(primary_key(key), 1, limit, with_scores: with_scores) || []
        end

        def top_intervals(key, with_scores: false, limit: LIMIT, format: :month, offset: 0)
          ikey = send("#{format}_key", offset: offset)
          top("#{key}:#{ikey}", with_scores: with_scores, limit: limit)
        end
      end

    end
  end
end
