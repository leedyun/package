require 'spec_helper'

describe "attributes validation" do

  before :all do
    class Person
      include ActiveModel::Model

      attr_accessor :name, :age
      validates_presence_of :name
      validates_presence_of :age
    end
  end
  subject(:person){ Person.new }

  context "extended model" do
    before do
      class Person
        include ActiveModel::AttributesValidation
      end
    end

    it { should respond_to :attributes_valid? }
  end

  context "#attributes_valid?" do
    context "for a specific attribute" do
      it 'returns false if validation only this attribute fails' do
        person.name = nil
        expect(person.attributes_valid? :name).to be_false
      end

      it 'returns true if only this attribute valid' do
        person.name = 'name'
        person.age = nil
        expect(person.attributes_valid? :name).to be_true
      end
    end
    context 'errors' do
      it 'fills errors only for this attribute' do
        person.name = person.age = nil
        person.attributes_valid? :name

        expect(person.errors.size).to eq 1
        expect(person.errors[:name]).to eq ["can't be blank"]
        expect(person.errors[:age]).to be_empty
      end

      it 'clears errors between calls' do
        person.name = nil
        person.attributes_valid? :name

        expect(person.errors.size).to eq 1

        person.name = 'name'
        person.attributes_valid? :name
        expect(person.errors.size).to eq 0
      end

      it 'return same errors as #valid? if all attributes present in params' do
        person.name = person.age = nil
        person.valid?
        standard_errors = person.errors.dup

        person.attributes_valid? :name, :age
        expect(standard_errors.messages).to eq person.errors.messages
      end
    end

    context 'validation callbacks' do
      it 'do not if they not present' do
        person.stub(:run_callbacks)
        person.attributes_valid? :name
        expect(person).not_to have_received(:run_callbacks)
      end

      it 'run if they present' do
        class Person
          include ActiveModel::Validations::Callbacks
        end
        person.stub(:run_callbacks)
        person.attributes_valid? :name
        expect(person).to have_received(:run_callbacks)
      end
    end
  end
end
