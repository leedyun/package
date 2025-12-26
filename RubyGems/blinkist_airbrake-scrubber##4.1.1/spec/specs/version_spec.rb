
require 'spec_helper'
require 'blinkist-airbrake-scrubber/version'

describe Blinkist::AirbrakeScrubber::VERSION do

  it 'provides the current version' do
    version = Blinkist::AirbrakeScrubber::VERSION
    expect(version).to_not be nil
    expect(version.instance_of?(String)).to be true
  end

  it 'equals 4.0.1 for auto-check purposes' do
    version = Blinkist::AirbrakeScrubber::VERSION
    expect(version).to eq '4.1.1'
  end

end
