require 'spec_helper'

describe BehaviorValidator do
  describe '.valid?' do
    subject do
      described_class.valid?(0, options)
    end

    context 'when the object responds to option keys' do
      context 'and returns the corresponding value' do
        let(:options) do
          { zero?: true }
        end

        it { should be_truthy }
      end

      context 'and does not return the corresponding value' do
        let(:options) do
          { zero?: false }
        end

        it { should be_falsey }
      end
    end

    context 'when the object does not respond to option keys' do
      let(:options) do
        { unknown_method: false }
      end

      it { should be_falsey }
    end

    context 'when the options have reserved keys' do
      let(:options) do
        { zero?: true }
      end

      before do
        described_class.reserved_options.each do |reserved_option|
          options[reserved_option] = true
        end
      end

      it 'does not affect to the result' do
        expect(described_class.valid?(0, options)).to be_truthy
        expect(described_class.valid?(1, options)).to be_falsey
      end
    end
  end

  describe 'validations' do
    subject do
      model_class.new(attr: 0)
    end

    let(:model_class) do
      opts = options
      Class.new(TestModel) do
        validates :attr, behavior: opts
      end
    end

    context 'when the object responds to option keys' do
      context 'and returns the corresponding value' do
        let(:options) do
          { zero?: true }
        end

        it { should be_valid }
      end

      context 'and does not return the corresponding value' do
        let(:options) do
          { zero?: false }
        end

        it { should be_invalid }
      end
    end

    context 'when the options have reserved keys' do
      let(:options) do
        {
          zero?: true,

          # Reserved by ActiveModel.
          allow_nil: true,
          allow_blank: true,
          message: 'hello',
          if: -> { true },
          unless: -> { false }
          # on: :create
        }
      end

      it 'does not affect to the result' do
        expect(model_class.new(attr: 0)).to be_valid
        expect(model_class.new(attr: 1)).to be_invalid
      end
    end
  end
end
