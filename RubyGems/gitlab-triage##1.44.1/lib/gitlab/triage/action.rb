# frozen_string_literal: true

require_relative 'action/summarize'
require_relative 'action/comment'
require_relative 'action/comment_on_summary'
require_relative 'action/issue'
require_relative 'action/delete'

module Gitlab
  module Triage
    module Action
      def self.process(policy:, **args)
        policy.validate!

        [
          [Summarize, policy.summarize?],
          [Comment, policy.comment?],
          [CommentOnSummary, policy.comment_on_summary?],
          [Issue, policy.issue?],
          [Delete, policy.delete?]
        ].each do |action, active|
          act(action: action, policy: policy, **args) if active
        end
      end

      def self.act(action:, dry:, **args)
        klass =
          if dry
            action.const_get(:Dry)
          else
            action
          end

        klass.new(**args).act
      end
    end
  end
end
