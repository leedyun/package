require 'spec_helper'

describe ActsAsExplorable::Query do

  let(:zlatan) { create(:zlatan) }
  let(:manuel) { create(:manuel) }
  let(:bastian) { create(:bastian) }
  let(:christiano) { create(:christiano) }
  let(:toni) { create(:toni) }
  let(:fernando) { create(:fernando) }

  context 'in:' do
    it '`first_name` should find by first name' do
      [zlatan, christiano]
      expect(Player.search('Zlatan in:first_name').count).to eq(1)
    end

    it '`club` should find by club' do
      [zlatan, manuel, bastian]
      expect(Player.search('Bayern in:club').count).to eq(2)
    end

    it '`city` should find by city' do
      [zlatan, bastian, christiano, toni, fernando]
      expect(Player.search('Madrid in:city').count).to eq(3)
    end
  end

  context 'sort:' do
    before(:each) do
      [christiano, zlatan, bastian]
    end

    it '`first_name` should order descending by first name' do
      expect(Player.search('sort:first_name').first).to eq(zlatan)
    end

    it '`first_name-desc` should order descending by first name' do
      expect(Player.search('sort:first_name-desc').first).to eq(zlatan)
    end

    it '`first_name-asc` should order ascending by first name' do
      expect(Player.search('sort:first_name-asc').last).to eq(zlatan)
    end

    it '`position-desc,first_name-asc` should order by position then by first name' do
      expect(Player.search('sort:position-desc,first_name-asc').first).to eq(bastian)
    end
  end

end
