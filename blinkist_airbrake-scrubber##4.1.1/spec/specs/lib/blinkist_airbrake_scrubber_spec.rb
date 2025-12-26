require 'spec_helper'
require 'securerandom'
require 'blinkist-airbrake-scrubber'

describe Blinkist::AirbrakeScrubber do
  let(:instantiate_airbrake) {
    Airbrake.configure :"notifier_#{ SecureRandom.uuid }" do |c|
      c.project_id  = 1
      c.project_key = 'whatever'
    end
  }

  describe "Constants" do
    it "has FILTERED constant" do
      expect(Blinkist::AirbrakeScrubber.constants).to include(:FILTERED)
    end

    it "has explicit FILTERED constant content" do
      expect(Blinkist::AirbrakeScrubber::FILTERED).to eq('[Filtered]')
    end

    it "has SCRUBBERS constant" do
      expect(Blinkist::AirbrakeScrubber.constants).to include(:SCRUBBERS)
    end

    it "has list of scrubbers in SCRUBBERS" do
      expect(Blinkist::AirbrakeScrubber::SCRUBBERS.is_a?(Array)).to be true
    end
  end

  describe ".configure(*args, &block)" do
    it "calls super Airbrake.configure(*args, &block)" do
      expect(Airbrake).to receive(:configure)
      instantiate_airbrake
    end

    it "calls Blinkist::AirbrakeScrubber.run!" do
      expect(Blinkist::AirbrakeScrubber).to receive(:run!)
      instantiate_airbrake
    end
  end

  describe "self.run!" do
    it "runs ::scrub! for every scrubber declared in SCRUBBERS" do
      Blinkist::AirbrakeScrubber::SCRUBBERS.each do |scrubber|
        expect(scrubber).to receive(:scrub!)
      end
      instantiate_airbrake
    end
  end

end
