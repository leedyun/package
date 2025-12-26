require 'spec_helper'

describe HaloStats::Profile do
  let (:profile_client) {HaloStats::Profile.new(api_key: 'fakekey')}

  context 'get' do
    it 'returns a string for get_emblem' do
      expect(profile_client.get_emblem('faketag')).to be_an(String)
    end

    it 'returns a string for get_spartan_image' do
      expect(profile_client.get_spartan_image('faketag')).to be_an(String)
    end
  end
end
