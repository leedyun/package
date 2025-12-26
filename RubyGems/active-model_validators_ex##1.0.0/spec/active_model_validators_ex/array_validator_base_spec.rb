require 'spec_helper'

describe ArrayValidatorBase do
  describe '.custom_validations' do
    context 'if method is not overridden' do
      it 'raises error' do
        expect do
          validator.custom_validations(nil, nil, nil)
        end.to raise_error
      end
    end
  end

  describe '.validate_each' do
    let(:record)    { MockRecord.new }
    let(:attribute) { :array }
    let(:validator) { ArrayValidatorBase.new(options) }
    before do
      validator.validate_each(record, attribute, value) rescue nil
    end

    shared_examples_for :common_behavior do
      context 'value is a non nil, non array value' do
        let(:value) { :symbol }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end
    end

    shared_examples_for :allow_nil_true do
      context 'value is nil' do
        let(:value) { nil }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end
    end

    shared_examples_for :allow_nil_false do
      context 'value is nil' do
        let(:value) { nil }

        it 'sets error message in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end
    end

    shared_examples_for :allow_blank_true do
      context 'value is an blank Array' do
        let(:value) { [] }

        it 'does not set error messages in record' do
          expect(record.errors[attribute].count).to eq(0)
        end
      end
    end

    shared_examples_for :allow_blank_false do
      context 'value is an blank Array' do
        let(:value) { [] }

        it 'set error messager in record' do
          expect(record.errors[attribute].count).to eq(1)
        end
      end
    end

    context 'for instance initialized with no options (defaults test)' do
      let(:options) { { attributes: attribute } }

      it_behaves_like :common_behavior
      it_behaves_like :allow_nil_false
      it_behaves_like :allow_blank_false
    end

    context 'for instance initialized with allow_blank true' do
      let(:options) { { attributes: attribute, allow_blank: true } }

      it_behaves_like :common_behavior
      it_behaves_like :allow_blank_true
    end

    context 'for instance initialized with allow_blank false' do
      let(:options) { { attributes: attribute, allow_blank: false } }

      it_behaves_like :common_behavior
      it_behaves_like :allow_blank_false
      it_behaves_like :allow_nil_false
    end

    context 'for instance initialized with allow_nil true' do
      let(:options) { { attributes: attribute, allow_nil: true } }

      it_behaves_like :common_behavior
      it_behaves_like :allow_nil_true
      it_behaves_like :allow_blank_false

      context 'and allow_blank true' do
        let(:options) do
          { attributes: attribute, allow_nil: true, allow_blank: true }
        end

        it_behaves_like :common_behavior
        it_behaves_like :allow_nil_true
        it_behaves_like :allow_blank_true
      end

      context 'and allow_blank false' do
        let(:options) do
          { attributes: attribute, allow_nil: true, allow_blank: false }
        end

        it_behaves_like :common_behavior
        it_behaves_like :allow_nil_true
        it_behaves_like :allow_blank_false
      end
    end

    context 'for instance initialized with allow_nil false' do
      let(:options) { { attributes: attribute, allow_nil: false } }

      it_behaves_like :common_behavior
      it_behaves_like :allow_nil_false
      it_behaves_like :allow_blank_false

      context 'and allow_blank true' do
        let(:options) do
          { attributes: attribute, allow_nil: false, allow_blank: true }
        end

        it_behaves_like :common_behavior
        it_behaves_like :allow_blank_true
      end

      context 'and allow_blank false' do
        let(:options) do
          { attributes: attribute, allow_nil: false, allow_blank: false }
        end

        it_behaves_like :common_behavior
        it_behaves_like :allow_nil_false
        it_behaves_like :allow_blank_false
      end
    end
  end
end