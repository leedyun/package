require 'spec_helper'

RSpec.describe ActiveModel::Permalink do
  subject { TestClass.new }
  
  context 'if permalink is not present' do
    before do
      subject.permalink = nil
    end
    
    context 'and :name is present' do
      before do
        subject.name = 'Name Of Model'
        subject.title = 'Title Of Model'
        subject.valid? # trigger callback
      end
      
      it 'generates from the :name attribute' do
        expect(subject.permalink).to eql('name-of-model')
      end
    end
    
    context 'and :name is not present but :title is' do
      before do
        subject.name = nil
        subject.title = 'Title Of Model'
        subject.valid? # trigger callback
      end
      
      it 'uses the :title attribute to generate the permalink from' do  
        expect(subject.permalink).to eql('title-of-model')
      end
    end
  end
  
  context 'if permalink is present already' do

    before do
      subject.permalink = 'already-existing'
      subject.valid? # trigger the callback
    end
    
    it 'respects the value' do
      subject.permalink = 'already-existing'
    end
  end  
end
