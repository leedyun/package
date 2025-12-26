require 'spec_helper'

describe GrapePathHelpers::RouteDisplayer do
  subject(:route_displayer) { described_class.new }

  describe '#route_attributes' do
    subject { route_displayer.route_attributes }

    it 'returns the list of attributes' do
      is_expected.to include(a_hash_including(
                               route_path: '/:version/ping(.:format)',
                               route_method: 'GET',
                               helper_names: ['beta_1_ping_path'],
                               helper_arguments: []
                             ))
    end
  end
end
