require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe GrapePathHelpers::AllRoutes do
  Grape::API::Instance.extend described_class

  describe '#all_routes' do
    context 'when API is mounted within another API' do
      let(:mounting_api) { Spec::Support::MountedAPI }

      it 'does not include the same route twice' do
        mounting_api

        # A route is unique if no other route shares the same set of options
        all_route_options = Grape::API::Instance.all_routes.map do |r|
          r.instance_variable_get(:@options).merge(path: r.path)
        end

        duplicates = all_route_options.select do |o|
          all_route_options.count(o) > 1
        end

        expect(duplicates).to be_empty
      end
    end

    # rubocop:disable Metrics/LineLength
    context 'when there are multiple POST routes with the same namespace in the same API' do
      it 'returns all POST routes' do
        expected_routes = Spec::Support::MultiplePostsAPI.routes.map(&:path)

        all_routes = Grape::API::Instance.all_routes
        expect(all_routes.map(&:path)).to include(*expected_routes)
      end
    end

    context 'when an API is created via an intermediate class' do
      it 'includes those routes on both Grape::API::Instance and the base class' do
        expect(Spec::Support::BaseAPI.all_routes.map(&:origin)).to include('/derived_ping')
        expect(Grape::API::Instance.all_routes.map(&:origin)).to include('/derived_ping')
      end
    end
    # rubocop:enable Metrics/LineLength
  end
end
# rubocop:enable Metrics/BlockLength
