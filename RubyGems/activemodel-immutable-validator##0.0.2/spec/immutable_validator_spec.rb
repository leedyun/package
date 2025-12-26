describe ImmutableValidator do
  describe 'validation' do
    subject(:model) do
      model_class.new(attr: value)
    end

    let(:model_class) do
      Class.new(TestModel) do
        validates :attr, immutable: true
      end
    end

    let(:value) do
      'foo'
    end

    context 'on create' do
      before do
        allow(model).to receive(:new_record?).and_return(true)
        allow(model).to receive(:attr_changed?).and_return(true)
      end

      it { should be_valid }
    end

    context 'on update' do
      before do
        allow(model).to receive(:new_record?).and_return(false)
      end

      context 'with change' do
        before do
          allow(model).to receive(:attr_changed?).and_return(true)
        end

        it { should be_invalid }
      end

      context 'without change' do
        before do
          allow(model).to receive(:attr_changed?).and_return(false)
        end

        it { should be_valid }
      end
    end
  end
end
