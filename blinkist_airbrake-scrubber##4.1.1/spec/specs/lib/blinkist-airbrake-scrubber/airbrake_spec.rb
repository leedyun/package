require 'spec_helper'
require 'blinkist-airbrake-scrubber'

describe Airbrake do
  let(:instantiate_airbrake) {
    Airbrake.configure :"notifier_#{ SecureRandom.uuid }" do |c|
      c.project_id  = 1
      c.project_key = 'whatever'
    end
  }

  describe "Module#prepend" do
    it "does have Blinkist::AirbrakeScrubber as one of the ancestors" do
      expect(described_class.ancestors).to include(Blinkist::AirbrakeScrubber)
    end
  end

  describe '.configure' do
    it "does call Blinkist::AirbrakeScrubber.configure" do
      expect_any_instance_of(Blinkist::AirbrakeScrubber).to receive(:configure)
      instantiate_airbrake
    end
  end
end
