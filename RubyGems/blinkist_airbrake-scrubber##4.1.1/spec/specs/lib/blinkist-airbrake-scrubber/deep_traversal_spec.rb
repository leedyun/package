require 'spec_helper'
require 'blinkist-airbrake-scrubber'

describe Blinkist::AirbrakeScrubber::DeepTraversal do
  subject { described_class.new(source) }

  let(:source) { Hash.new }

  describe ".traverse" do
    it "calls .recursive_traverse" do
      expect(subject).to receive(:recursive_traverse).with(source)
      subject.traverse { |k, v| v }
    end
  end

  context "For single-level hashes" do
    let(:source) { { email: 'user@example.org', password: 'whatever', param: true } }

    it "filters out any key" do
      returned_object = subject.traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq({ email: '[Filtered]', password: 'whatever', param: true })
    end

    it "filters out any keys" do
      returned_object = subject.traverse { |k, v| %w{ email password }.include?(k.to_s) ? '[Filtered]' : v }
      expect(returned_object).to eq({ email: '[Filtered]', password: '[Filtered]', param: true })
    end
  end

  context "For deeply-nested hashes" do
    let(:source) { { email: 'user@example.org', params: { email: 'user@example.org', contact: { email: 'user@example.org' } } } }

    it "filters out all keys" do
      returned_object = subject.traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq({ email: '[Filtered]', params: { email: '[Filtered]', contact: { email: '[Filtered]' } } })
    end
  end

  context "For hashes with arrays" do
    let(:source) { { email: 'user@example.org', emails: [ { email: 'user@example.org' }, { email: 'user@example.org' } ], whatever: [ nil ] } }

    it "filters out all keys" do
      returned_object = subject.traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq({ email: '[Filtered]', emails: [ { email: '[Filtered]' }, { email: '[Filtered]' } ], whatever: [ nil ] })
    end
  end

  context "For arrays" do
    let(:source) { [ { email: 'user@example.org' }, { email: 'user@example.org' } ] }

    it "filters out all keys" do
      returned_object = subject.traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq([ { email: '[Filtered]' }, { email: '[Filtered]' } ])
    end
  end

  context "For simple objects (non-hash, non-array)" do
    it "doesn't break String" do
      returned_object = described_class.new("Sample").traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq("Sample")
    end

    it "doesn't break Fixnum" do
      returned_object = described_class.new(1).traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq(1)
    end

    it "doesn't break Float" do
      returned_object = described_class.new(3.14).traverse { |k, v| k.to_s == 'email' ? '[Filtered]' : v }
      expect(returned_object).to eq(3.14)
    end
  end
end
