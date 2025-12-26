require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe GrapePathHelpers::NamedRouteMatcher do
  include described_class

  let(:helper_class) do
    fake_class = Class.new do
      prepend GrapePathHelpers::NamedRouteMatcher

      def method_missing(method_id, *args, **kwargs)
        [method_id, args, kwargs] || super
      end

      def respond_to_missing?(_method_name, _include_private = false)
        super
      end
    end

    fake_class.new
  end

  it 'is available inside Grape endpoints' do
    endpoint = Spec::Support::API.endpoints.first

    expect(endpoint.api_v1_cats_path(id: 5))
      .to eq('/api/v1/cats/5.json')
  end

  describe '#method_missing' do
    it 'returns super method_missing if the route does not exist' do
      expect(helper_class.test_method(id: 1))
        .to eq([:test_method, [], { id: 1 }])
    end

    it 'returns super method_missing if first arg is not a hash' do
      expect(helper_class.api_v1_cats_path(:arg1, kwarg1: :kwarg1))
        .to eq([:api_v1_cats_path, [:arg1], { kwarg1: :kwarg1 }])
    end

    context 'when method name matches a Grape::Route path helper name' do
      it 'returns the path for that route object' do
        expect(helper_class.api_v1_ping_path).to eq('/api/v1/ping.json')
      end

      context 'when route contains dynamic segments' do
        it 'returns the path for that route object' do
          expect(helper_class.api_v1_cats_path(id: 5))
            .to eq('/api/v1/cats/5.json')
        end
      end

      context 'when route requires dynamic segments but none are passed in' do
        it 'returns super method_missing' do
          expect(helper_class.api_v1_cats_owners_path)
            .to eq([:api_v1_cats_owners_path, [], {}])
        end
      end

      context 'when route has no dynamic segments but some are passed in' do
        it 'returns super method_missing' do
          expect(helper_class.api_v1_ping_path(invalid: 'test'))
            .to eq([:api_v1_ping_path, [], { invalid: 'test' }])
        end
      end
    end
  end

  describe '#respond_to_missing?' do
    context 'when method name doesnt end with _path suffix' do
      let(:method_name) { :api_v1_cats }

      it 'returns false' do
        expect(respond_to_missing?(method_name)).to eq(false)
      end

      it 'doesnt execute decorated_routes_by_helper_name method' do
        expect(Grape::API::Instance)
          .not_to receive(:decorated_routes_by_helper_name)

        respond_to_missing?(method_name)
      end
    end

    context 'when method name matches a Grape::Route path with segments' do
      let(:method_name) { :api_v1_cats_path }

      it 'returns true' do
        expect(respond_to_missing?(method_name)).to eq(true)
      end
    end

    context 'when method name matches a Grape::Route path' do
      let(:method_name) { :api_v1_ping_path }

      it 'returns true' do
        expect(respond_to_missing?(method_name)).to eq(true)
      end
    end

    context 'when method name does not match a Grape::Route path' do
      let(:method_name) { :some_other_path }

      it 'returns false' do
        expect(respond_to_missing?(method_name)).to eq(false)
      end
    end
  end

  context 'when Grape::Route objects share the same helper name' do
    context 'when helpers require different segments to generate their path' do
      it 'uses arguments to infer which route to use' do
        show_path = helper_class.api_v1_cats_path(
          'id' => 1
        )
        expect(show_path).to eq('/api/v1/cats/1.json')

        index_path = helper_class.api_v1_cats_path
        expect(index_path).to eq('/api/v1/cats.json')
      end

      it 'does not get shadowed by another route with less segments' do
        show_path = helper_class.api_v1_cats_owners_path(
          'id' => 1
        )
        expect(show_path).to eq('/api/v1/cats/1/owners.json')

        show_path = helper_class.api_v1_cats_owners_path(
          'id' => 1,
          'owner_id' => 1
        )
        expect(show_path).to eq('/api/v1/cats/1/owners/1.json')
      end
    end

    context 'when query params are passed in' do
      it 'uses arguments to infer which route to use' do
        show_path = helper_class.api_v1_cats_path(
          'id' => 1,
          params: { 'foo' => 'bar' }
        )

        expect(show_path).to eq('/api/v1/cats/1.json?foo=bar')

        index_path = helper_class.api_v1_cats_path(
          params: { 'foo' => 'bar' }
        )
        expect(index_path).to eq('/api/v1/cats.json?foo=bar')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
