require 'spec_helper'

describe ActiveValidator::Base do
  before do
    @params = { foo: 123, bar: 456 }
    @params.stub(:permit).and_return(@params)
  end

  describe 'core functionality' do
    it 'should return false when validation rules are not met' do
      v = ActiveValidator::MySubClass.new(@params)
      v.foo = ''
      expect(v.valid?).to eq(false)
    end

    it 'should return true when validation rules are met' do
      v = ActiveValidator::MySubClass.new(@params)
      expect(v.valid?).to eq(true)
    end
  end

  describe 'setup_attributes()' do
    it 'should create custom attr_accessor methods in subclass' do
      v = ActiveValidator::MySubClass.new(@params)
      expect(v.respond_to?(:foo)).to eq(true)
    end

    it 'should assign values from params to custom attr_accessors subclass' do
      v = ActiveValidator::MySubClass.new(@params)
      expect(v.foo).to eq(123)
    end
  end

  describe 'error_messages()' do
    it 'should return a properly formatted error hash if errors exist' do
      v = ActiveValidator::MySubClass.new(@params)
      v.foo = ''
      v.valid?
      expect(v.error_messages).to eq({:error=>["Foo can't be blank"]})
    end

    it 'should return nil if no errors exist' do
      v = ActiveValidator::MySubClass.new(@params)
      v.valid?
      expect(v.error_messages).to eq(nil)
    end
  end
end
