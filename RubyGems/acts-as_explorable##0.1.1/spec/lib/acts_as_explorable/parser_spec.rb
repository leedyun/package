require 'spec_helper'

describe ActsAsExplorable::Parser do

  subject { ActsAsExplorable::Parser }

  describe '#new' do
    it 'should be called with a query string' do
      expect { subject.new }.to raise_error
    end
  end

  describe '.transform' do
    it 'should respond with a hash' do
      expect(subject.transform('Zlatan in:first_name')).to be_a(Hash)
    end

    it 'should have a result with :values and :params keys' do
      expect(subject.transform('Zlatan in:first_name'))
        .to  have_key(:values)
        .and have_key(:params)
    end

    it 'should not have a result with a key :props' do
      expect(subject.transform('Zlatan in:first_name'))
        .not_to have_key(:props)
    end

    it 'should transform the string to a hash' do
      expect(subject.transform('Zlatan in:first_name'))
        .to eq(values: ['Zlatan'], params: { in: ['first_name'] })
    end
  end

end
