require 'spec_helper'

RSpec.describe CountValidator do
  before do
    stub_const('OwnerClass', Class.new(Owner))
  end

  describe 'success' do
    let(:owner) { OwnerClass.new }

    before do
      OwnerClass.validates :pets, :count => {:minimum => 2}
      owner.pets = [Pet.new, Pet.new]
    end

    it { expect(owner).to be_valid }
  end

  describe 'failure' do
    let(:owner) { OwnerClass.new }

    before do
      OwnerClass.validates :pets, :count => {:minimum => 2}
    end

    it do
      expect(owner).to be_invalid
      expect(owner.errors).to include(:pets)
    end
  end

  context 'when associated records are marked for destruction' do
    let(:owner) { OwnerClass.new(pets: [Pet.new, Pet.new]) }

    before do
      OwnerClass.validates :pets, :count => {:maximum => 1}
      owner.pets.last.mark_for_destruction
    end

    it 'does not count associated records marked for destruction' do
      expect(owner).to be_valid
    end
  end

  context 'with no optional error messages' do
    let(:owner) { OwnerClass.new }

    before do
      OwnerClass.validates :pets, :count => {:minimum => 1}
      owner.save
    end

    it "uses it's own default error messages" do
      expect(owner.errors[:pets]).to eq([I18n.t('errors.messages.count_greater_than_or_equal_to.one')])
    end
  end

  context 'with optional error message' do
    let(:owner) { OwnerClass.new }

    before do
      OwnerClass.validates :pets, :count => {:minimum => 1, :too_short => 'optional message'}
      owner.save
    end

    it 'uses optional error message' do
      expect(owner.errors[:pets]).to eq(['optional message'])
    end
  end
end
