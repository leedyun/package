require 'spec_helper'

describe AttributeNormalizer::Normalizers::PostalCodeNormalizer do

  describe '.normalizer' do
    it 'removes underscores' do
      expect(subject.normalize "____T1T1T1", {}).to eq "T1T1T1"
    end

    it 'removes dashes' do
      expect(subject.normalize "T1T-1T1", {}).to eq "T1T1T1"
    end

    it 'removes whitespace' do
      expect(subject.normalize " T1T 1T1 ", {}).to eq "T1T1T1"
    end

    it 'upcases lowercase text' do
      expect(subject.normalize "t6h1v2", {}).to eq "T6H1V2"
    end

    it 'returns nil if value is nil' do
      expect(subject.normalize nil, {}).to be_nil
    end

  end

end
