# AWS SNS Subscription Confirmation for Ruby on Rails

If you use AWS SNS for notifications (such as email bounces or complaints), you'll need to confirm the subscription request.

This makes that easier for Ruby on Rails apps.

## Instructions

### Step 1: Add the gem to your gemfile

`gem "aws_sns_subscription"`

### Step 2: Add a before filter to the controllers that you're using as endpoints

    class ExampleEmailBouncesController < ApplicationController
      before_filter :respond_to_aws_sns_subscription_confirmations, only: [:create]
    end
