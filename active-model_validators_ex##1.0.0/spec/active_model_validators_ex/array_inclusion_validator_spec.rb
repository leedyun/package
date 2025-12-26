require 'spec_helper'

describe ArrayInclusionValidator do
  describe '.new' do
    context 'when key :in is not present in argument hash' do
      let(:options) { { attributes: :something } }

      it 'raises error' do
        expect do
          ArrayInclusionValidator.new(options)
        end.to raise_error
      end
    end
  end

  describe '#validate_each' do
    let(:record)    { MockRecord.new }
    let(:attribute) { :array }
    let(:validator) { ArrayInclusionValidator.new(options) }
    before { validator.validate_each(record, attribute, value) }

    context 'for instance initialized with key in with an Array of values' do
      let(:in_array) { [1, 2, 3] }
      let(:options) do
        { attributes: attribute, in: in_array }
      end

      context 'when passed value is an array with values that are in options array' do
        let(:value) { [1, 2, 3] }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when passed value is an array with values not in options array' do
        let(:value) { [4, 5, 6] }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end
    end

    context 'for instance initialized with key in with a Range of values' do
      let(:in_range) { 1..3 }
      let(:options) do
        { attributes: attribute, in: in_range }
      end

      context 'when passed value is an array with values that are in options array' do
        let(:value) { [1, 2, 3] }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when passed value is an array with values not in options array' do
        let(:value) { [4, 5, 6] }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end
    end
  end
end