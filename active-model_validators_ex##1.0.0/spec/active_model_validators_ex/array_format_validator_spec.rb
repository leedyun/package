require 'spec_helper'

describe ArrayFormatValidator do
  describe '.new' do
    context 'when key with is not present in argument hash' do
      let(:options) { { attributes: :something } }

      it 'raises error' do
        expect do
          ArrayFormatValidator.new(options)
        end.to raise_error
      end
    end

    context 'when key with is a non Regexp value' do
      let(:options) { { attributes: :something, with: 'not an regexp' } }

      it 'raises error' do
        expect do
          ArrayFormatValidator.new(options)
        end.to raise_error
      end
    end
  end

  describe '#validate_each' do
    let(:record)    { MockRecord.new }
    let(:attribute) { :array }
    let(:validator) { ArrayFormatValidator.new(options) }
    before { validator.validate_each(record, attribute, value) }

    context 'for instance initialized with regexp value in key :with' do
      let(:regexp) { /(testing|one|two)/ }
      let(:options) do
        { attributes: attribute, with: regexp }
      end

      context 'when value is an Array with values that match regexp' do
        let(:value) { ['testing', 'one', 'two'] }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end

      context 'when value is an array with values that do not match regexp' do
        let(:value) { ['i do not match'] }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end
    end
  end
end