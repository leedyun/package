require 'spec_helper'

describe Log do
  let(:log) { described_class }
  let(:logger) { double(:logger) }

  before do
    allow(Log).to receive(:logger).and_return(logger)
  end

  it 'forwards to Logging' do
    expect(logger).to receive(:warn).with('foo')
    Log.warn('foo')
  end
end
