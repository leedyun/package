require 'spec_helper'

describe AttributeNormalizer::Normalizers::FloatNormalizer do
  describe '#normalize' do
    let(:normalized) { described_class.normalize(value, opts) }

    context 'with an Integer' do
      let(:value) { 2 }
      let(:opts) { Hash.new }

      it 'returns a float' do
        expect(normalized).to eq(2.0) # be careful: 2 == 2.to_f
        expect(normalized).to be_a(Float)
      end
    end

    context 'with nil' do
      let(:value) { nil }

      context 'with allow_blank: false' do
        let(:opts) { { allow_blank: false } }

        it 'returns nil.to_f (0.00)' do
          expect(normalized).to eq(nil.to_f)
        end
      end

      context 'with allow_blank: true' do
        let(:opts) { { allow_blank: true } }

        it 'returns nil' do
          expect(normalized).to be nil
        end
      end
    end

    context 'with a String' do
      let(:value) { '$1,500.01' }
      let(:opts) { Hash.new }

      it 'strips out invalid characters' do
        expect(normalized).to eq(1500.01)
      end
    end

    context 'with an empty String' do
      let(:value) { '' }

      context 'with allow_blank: false' do
        let(:opts) { { allow_blank: false } }

        it 'returns "".to_f (0.00)' do
          expect(normalized).to eq(''.to_f)
        end
      end

      context 'with allow_blank: true' do
        let(:opts) { { allow_blank: true } }

        it 'returns the empty string' do
          expect(normalized).to eq('')
        end
      end
    end

    context 'with an invalid type' do
      let(:value) { Array.new }
      let(:opts) { Hash.new }

      it 'raises ArgumentError' do
        expect{ normalized }.to raise_error(ArgumentError)
      end
    end
  end
end
