require 'spec_helper'

describe HaloStats::Metadata do
  let (:metadata_client) {HaloStats::Metadata.new(api_key: 'fakekey')}

  context 'get' do
    it 'returns a hash for get_campaign_missions' do
      expect(metadata_client.get_campaign_missions).to be_a(Array)
    end

    it 'returns a hash for get_commendations' do
      expect(metadata_client.get_commendations).to be_a(Array)
    end

    it 'returns a hash for get_csr_designations' do
      expect(metadata_client.get_csr_designations).to be_a(Array)
    end

    it 'returns a hash for get_enemies' do
      expect(metadata_client.get_enemies).to be_a(Array)
    end

    it 'returns a hash for get_flexible_stats' do
      expect(metadata_client.get_flexible_stats).to be_a(Array)
    end

    it 'returns a hash for get_game_base_variants' do
      expect(metadata_client.get_game_base_variants).to be_a(Array)
    end

    it 'returns a hash for get_game_variants' do
      expect(metadata_client.get_game_variants(1)).to be_a(Array)
    end

    it 'returns a hash for get_impulses' do
      expect(metadata_client.get_impulses).to be_a(Array)
    end

    it 'returns a hash for get_map_variants' do
      expect(metadata_client.get_map_variants(1)).to be_a(Array)
    end

    it 'returns a hash for get_maps' do
      expect(metadata_client.get_maps).to be_a(Array)
    end

    it 'returns a hash for get_medals' do
      expect(metadata_client.get_medals).to be_a(Array)
    end

    it 'returns a hash for get_playlists' do
      expect(metadata_client.get_playlists).to be_a(Array)
    end

    it 'returns a hash for get_requisition_packs' do
      expect(metadata_client.get_requisition_packs(1)).to be_a(Array)
    end

    it 'returns a hash for get_requisitions' do
      expect(metadata_client.get_requisitions(1)).to be_a(Array)
    end

    it 'returns a hash for get_seasons' do
      expect(metadata_client.get_seasons).to be_a(Array)
    end

    it 'returns a hash for get_skulls' do
      expect(metadata_client.get_skulls).to be_a(Array)
    end

    it 'returns a hash for get_spartan_ranks' do
      expect(metadata_client.get_spartan_ranks).to be_a(Array)
    end

    it 'returns a hash for get_team_colors' do
      expect(metadata_client.get_team_colors).to be_a(Array)
    end

    it 'returns a hash for get_vehicles' do
      expect(metadata_client.get_vehicles).to be_a(Array)
    end

    it 'returns a hash for get_weapons' do
      expect(metadata_client.get_weapons).to be_a(Array)
    end

    it 'returns a hash for get_weapons' do
      expect(metadata_client.get_weapons).to be_a(Array)
    end
  end
end
