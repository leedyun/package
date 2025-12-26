require 'spec_helper'

shared_context 'valid base64 string is given', given: :valid do
  let(:value) do
    Base64.strict_encode64("Now is the time for all good coders\nto learn Ruby")
  end
end

shared_context 'invalid base64 string is given', given: :invalid do
  let(:value) do
    "Now is the time for all good coders\nto learn Ruby"
  end
end

shared_context 'nil is given', given: nil do
  let(:value) do
    nil
  end
end

describe Base64Validator do
  describe '.valid?' do
    subject do
      described_class.valid?(value)
    end

    context 'when a valid base64 string is given', given: :valid do
      it { should be_truthy }
    end

    context 'when a invalid base64 string is given', given: :invalid do
      it { should be_falsey }
    end
  end

  describe 'validation' do
    subject do
      model_class.new(attr: value)
    end

    context 'when option is true' do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, base64: true
        end
      end

      context 'and a valid base64 string is given', given: :valid do
        it { should be_valid }
      end

      context 'and a invalid base64 string is given', given: :invalid do
        it { should be_invalid }
      end

      context 'and nil is given', given: nil do
        it { should be_invalid }
      end
    end

    context 'when option is { allow_nil: true }' do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, base64: { allow_nil: true }
        end
      end

      context 'and a valid base64 string is given', given: :valid do
        it { should be_valid }
      end

      context 'and a invalid base64 string is given', given: :invalid do
        it { should be_invalid }
      end

      context 'and nil is given', given: nil do
        it { should be_valid }
      end
    end

    context 'when option is { allow_nil: false }' do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, base64: { allow_nil: false }
        end
      end

      context 'and a valid base64 string is given', given: :valid do
        it { should be_valid }
      end

      context 'and a invalid base64 string is given', given: :invalid do
        it { should be_invalid }
      end

      context 'and nil is given', given: nil do
        it { should be_invalid }
      end
    end
  end
end
