module Spec
  module Support
    # Test API
    class API < Grape::API::Instance
      version 'v1'
      prefix 'api'
      format 'json'

      get 'custom_name', as: :my_custom_route_name do
        'hello'
      end

      get 'ping' do
        'pong'
      end

      resource :cats do
        get '/' do
          %w[cats cats cats]
        end

        route_param :id do
          get do
            'cat'
          end
        end

        get ':id/(-/)optional' do
          'optional content'
        end

        get ':id/owners' do
          %w[owner1 owner2]
        end

        get ':id/owners/:owner_id' do
          'owner'
        end

        get ':id/owners/*owner_ids/cats' do
          %w[cats cats cats]
        end
      end

      route :any, '*path' do
        'catch-all route'
      end
    end

    # API with more than one version
    class APIWithMultipleVersions < Grape::API::Instance
      version %w[beta alpha v1]

      get 'ping' do
        'pong'
      end
    end

    # API with another API mounted inside it
    class MountedAPI < Grape::API::Instance
      mount Spec::Support::API
      mount Spec::Support::APIWithMultipleVersions
    end

    # API with a version that would be illegal as a method name
    class APIWithIllegalVersion < Grape::API::Instance
      version 'beta-1'

      get 'ping' do
        'pong'
      end
    end

    # API with multiple POST routes
    class MultiplePostsAPI < Grape::API::Instance
      resource :hamlet do
        post 'to_be' do
        end

        post 'or_not_to_be' do
        end
      end
    end

    class BaseAPI < Grape::API::Instance
    end

    class DerivedAPI < BaseAPI
      get 'derived_ping' do
        'pong'
      end
    end
  end
end
