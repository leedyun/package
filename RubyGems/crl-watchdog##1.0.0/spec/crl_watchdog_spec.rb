require 'spec_helper'

describe CrlWatchdog do
  let(:crl_file) { File.expand_path("../support/crl.pem", __FILE__) }

  subject { described_class.new crl_file }

  context 'with file input' do
    it 'requires an existing file' do
      expect do
        described_class.new '/does/not/exist.pem'
      end.to raise_error ArgumentError
    end

    it 'requires a valid certificate revokation list' do
      expect do
        described_class.new __FILE__
      end.to raise_error OpenSSL::X509::CRLError
    end

    it 'does not complain about a valid crl file' do
      expect do
        described_class.new crl_file
      end.not_to raise_error
    end

    it 'assigns OpenSSL::X509::CRL object to #crl' do
      expect(subject.crl).to be_instance_of OpenSSL::X509::CRL
    end
  end

  describe '#next_update' do
    it 'forwards to crl instance' do
      expect(subject.next_update).to be_instance_of Time
    end
  end

  describe '#expires_within_days?' do
    context 'with input sanitizing' do
      it 'accepts one argument' do
        expect(subject.method(:expires_within_days?).arity).to eql 1
      end

      it 'does not allow 0 days' do
        expect { subject.expires_within_days?(0) }.to raise_error ArgumentError
      end

      it 'does not allow negative values' do
        expect { subject.expires_within_days?(-1) }.to raise_error ArgumentError
      end

      it 'coerces input to integer' do
        expect { subject.expires_within_days?('14.5') }.not_to raise_error
      end

      it 'complains about failed coersion' do
        expect { subject.expires_within_days?('hello world') }.to raise_error ArgumentError
      end
    end

    context 'verifying next_update' do
      before do
        subject.stub(next_update: 10.days.from_now)
      end

      it 'return true if next_update is within requested time period' do
        expect(subject.expires_within_days?(9)).to eql true
      end

      it 'returns false if next_update is after requested time period' do
        expect(subject.expires_within_days?(11)).to eql false
      end
    end
  end

end
