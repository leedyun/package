require 'spec_helper'

describe Blinkist::AirbrakeScrubber::ParamsTokens do
  let(:notice) {
    Airbrake.build_notice(
      Exception.new('whatever'),
      { google_id_token: 'blahblah', facebook_access_token: 'whatever', param: 'whatever' }
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

    it "scrubs the google_id_token from the params hash" do
      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:google_id_token]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end

    it "scrubs the deep-nested google_id_token from the params hash" do
      notice = Airbrake.build_notice(
        Exception.new('whatever'),
        { google_id_token: 'bahblah', deeply: { nested: { google_id_token: 'blhablah' } } }
      )

      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:google_id_token]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
      expect(notice[:params][:deeply][:nested][:google_id_token]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end

    it "scrubs the facebook_access_token from the params hash" do
      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:facebook_access_token]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end

    it "scrubs the deep-nested facebook_access_token from the params hash" do
      notice = Airbrake.build_notice(
        Exception.new('whatever'),
        { facebook_access_token: 'bahblah', deeply: { nested: { facebook_access_token: 'blhablah' } } }
      )

      Airbrake.notice_notifier.instance_variable_get(:@filter_chain).refine(notice)
      expect(notice[:params][:facebook_access_token]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
      expect(notice[:params][:deeply][:nested][:facebook_access_token]).to eq(Blinkist::AirbrakeScrubber::FILTERED)
    end
  end

end
