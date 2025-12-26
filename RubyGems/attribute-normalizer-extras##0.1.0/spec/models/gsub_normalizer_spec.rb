require 'spec_helper'

describe AttributeNormalizer::Normalizers::GsubNormalizer do

  describe '.normalizer' do
    it 'replaces a pattern with a string' do
      normalized_text = subject.normalize "i am a string", pattern: /(i am)/, replacement: "you are"
      expect(normalized_text).to eq "you are a string"
    end
  end
end
