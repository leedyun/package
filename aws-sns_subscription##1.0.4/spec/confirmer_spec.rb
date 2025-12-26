require 'spec_helper'
require  File.expand_path('../../lib/aws_sns_subscription/confirmer.rb', __FILE__)
require  File.expand_path('../../lib/aws_sns_subscription/sns.rb', __FILE__)

module AWSSNSSubscription
  class Controller
    include AWSSNSSubscription::Confirmer
    def head(status)
    end
  end
  describe Confirmer do
    subject { Controller.new }
    describe "receiving the subcription confirmation request" do
      let(:raw_post) do
        File.read(File.expand_path("../fixtures/raw_post.txt", __FILE__))
      end
      let(:raw_bologna_post) do
        File.read(File.expand_path("../fixtures/raw_bologna_post.txt", __FILE__))
      end
      before(:each) do
        allow(subject).to receive(:request).and_return(double("request", headers: { "x-amz-sns-message-type" => "SubscriptionConfirmation" }, raw_post: raw_post))
      end
      it "should send a get request to the appropriate url" do
        expect(HTTParty).to receive(:get).with("https://sns.us-east-1.amazonaws.com/?Action=ConfirmSubscription&TopicArn=arn:aws:sns:us-east-1:123456789012:MyTopic&Token=2336412f37fb687f5d51e6e241d09c805a5a57b30d712f794cc5f6a988666d92768dd60a747ba6f3beb71854e285d6ad02428b09ceece29417f1f02d609c582afbacc99c583a916b9981dd2728f4ae6fdb82efd087cc3b7849e05798d2d2785c03b0879594eeac82c01f235d0e717736")
        subject.respond_to_aws_sns_subscription_confirmations
      end
      describe "with a bologna endpoint" do
        before(:each) do
          allow(subject).to receive(:request).and_return(double("request", headers: { "x-amz-sns-message-type" => "SubscriptionConfirmation" }, raw_post: raw_bologna_post))
        end
        it "should raise the right exception" do
          expect { subject.respond_to_aws_sns_subscription_confirmations }.to raise_error AWSSNSSubscription::Confirmer::MessageWasNotAuthentic
        end
      end
    end
    describe "not receiving a subscription confirmation request" do
      before(:each) do
        allow(subject).to receive(:request).and_return(double("request", headers: { "x-amz-sns-message-type" => nil }))
      end
      it "should not send a get request" do
        expect(HTTParty).to receive(:get).exactly(0).times
      end
    end
  end
end
