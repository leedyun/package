require 'spec_helper'

describe Blinkist::AirbrakeScrubber::ParamsPassword do
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

    it "scrubs the password from the params hash" do
      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:password]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end

    it "scrubs the deep-nested password from the params hash" do
      notice = Airbrake.build_notice(
        Exception.new('whatever'),
        { password: 'whatever', deeply: { nested: { password: 'whatever' } } }
      )

      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:password]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
      expect(notice[:params][:deeply][:nested][:password]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end
  end

end
