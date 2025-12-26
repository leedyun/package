require 'spec_helper'

describe Blinkist::AirbrakeScrubber::ParamsEmail do
  let(:notice) {
    Airbrake.build_notice(
      Exception.new('whatever'),
      { email: 'user@example.org', password: 'whatever', param: 'whatever' }
    )
  }

  describe "Structure" do
    it "has scrub! method" do
      expect(described_class).to respond_to(:scrub!)
    end
  end

  describe "self.scrub!" do
    it "adds the filter" do
      expect(Airbrake).to receive(:add_filter)
      described_class::scrub!
    end

    it "scrubs the email from the params hash" do
      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:email]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end

    it "scrubs the deep-nested email from the params hash" do
      notice = Airbrake.build_notice(
        Exception.new('whatever'),
        { email: 'user@example.org', deeply: { nested: { email: 'user@example.org' } } }
      )

      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:email]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
      expect(notice[:params][:deeply][:nested][:email]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end
  end

end
