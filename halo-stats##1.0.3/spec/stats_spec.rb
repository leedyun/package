require 'spec_helper'

describe HaloStats::Stats do
  let (:stats_client) {HaloStats::Stats.new(api_key: 'fakekey')}

  context 'get' do
    it 'returns a hash for get_matches' do
      expect(stats_client.get_matches('faketag')).to be_an(Hash)
    end

    it 'returns a hash for get_arena_carnage_report' do
      expect(stats_client.get_arena_carnage_report(1)).to be_an(Hash)
    end

    it 'returns a hash for get_campaign_carnage_report' do
      expect(stats_client.get_campaign_carnage_report(1)).to be_an(Hash)
    end

    it 'returns a hash for get_warzone_carnage_report' do
      expect(stats_client.get_warzone_carnage_report(1)).to be_an(Hash)
    end

    it 'returns a hash for get_custom_game_carnage_report' do
      expect(stats_client.get_custom_game_carnage_report(1)).to be_an(Hash)
    end

    it 'returns a hash for get_arena_service_record' do
      expect(stats_client.get_arena_service_record('faketag')).to be_an(Hash)
    end

    it 'returns a hash for get_warzone_service_record' do
      expect(stats_client.get_warzone_service_record('faketag')).to be_an(Hash)
    end

    it 'returns a hash for get_campaign_service_record' do
      expect(stats_client.get_campaign_service_record('faketag')).to be_an(Hash)
    end

    it 'returns a hash for get_custom_game_service_record' do
      expect(stats_client.get_custom_game_service_record('faketag')).to be_an(Hash)
    end
  end
end
