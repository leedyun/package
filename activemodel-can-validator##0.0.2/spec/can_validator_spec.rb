require 'spec_helper'

describe CanValidator do
  describe 'validation' do
    subject do
      model_class.new(attr: value)
    end

    let(:model_class) do
      Class.new(TestModel) do
        validates :attr, can: { positive_action: true, negative_action: false }
      end
    end

    context 'when the value object has CanCan interface' do
      let(:value) do
        Class.new do
          def can?(*args)
            false
          end

          def cannot?(*args)
            !can?(*args)
          end
        end.new
      end

      context 'and it can do positive_action and cannot do negative_action against the resource' do
        before do
          allow(value).to receive(:can?).with(:positive_action, a_kind_of(model_class)).and_return(true)
          allow(value).to receive(:can?).with(:negative_action, a_kind_of(model_class)).and_return(false)
        end

        it { should be_valid }
      end

      context "and it doesn't satisfy at least one required permission" do
        before do
          allow(value).to receive(:can?).with(:positive_action, a_kind_of(model_class)).and_return(true)
          allow(value).to receive(:can?).with(:negative_action, a_kind_of(model_class)).and_return(true)
        end

        it { should be_invalid }
      end
    end

    context 'when the value object does not have CanCan interface' do
      let(:value) do
        Object.new
      end

      it { should be_invalid }
    end
  end
end
