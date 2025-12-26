# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Slack
      class PostToSlackDry < PostToSlack
        def invoke!
          puts "The following message would have posted to Slack:"
          puts message
        end
      end
    end
  end
end
