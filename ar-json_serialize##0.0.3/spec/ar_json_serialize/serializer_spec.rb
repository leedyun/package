require 'spec_helper'
describe ::ArJsonSerialize::Serializer do
  %w(dump load).each do |k|
    it { should respond_to(k.to_sym) }
  end

  context '#load' do
    it 'should call MultiJson.load' do
      expect(::MultiJson).to receive(:load).with('string')
      subject.load('string')
    end

    [nil, ''].each do |k|
      it "should not call MultiJson.load if string is #{k.inspect}" do
        expect(::MultiJson).not_to receive(:load)
        subject.load(k)
      end

      it "should return empty if string is #{k.inspect}" do
        expect(subject.load(k)).to eq('')
      end

    end

    context 'content is' do
      subject { ::ArJsonSerialize::Serializer.load(data) }

      context 'String "foo"' do
        let(:data) { '"foo"' }
        it { should be_a(::String) }
        it { should == 'foo' }
      end

      context 'Hash {"key1":"value1"}' do
        let(:data) { '{"key1":"value1"}' }
        it { should be_a(::Hashie::Mash) }
        it { should == {'key1' => 'value1'} }

        describe '#key1' do
          subject { super().key1 }
          it { should == 'value1' }
        end
      end

      context 'Array' do
        context '["1", "2", "3"]' do
          let(:data) { '["1","2","3"]' }
          it { should be_a(::Array) }
          it { should == %w(1 2 3)}
        end

        context '["1","2","3",{"key1":"value1"}]' do
          let(:data) { '["1","2","3",{"key1":"value1"}]' }
          it { should be_a(::Array) }
          it { should == ['1', '2', '3', {"key1"=>"value1"}] }

          describe '#last' do
            subject { super().last }
            it { should be_a(::Hashie::Mash) }
          end
        end

      end

    end

  end

  context '#dump' do
    it 'should call MultiJson.dump' do
      expect(::MultiJson).to receive(:dump).with('foo')
      subject.dump('foo')
    end
  end

end