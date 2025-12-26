# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

describe OmniAuth::Strategies::MultiPassword do # rubocop:disable RSpec/SpecFilePathFormat
  include Rack::Test::Methods

  let(:app) do
    Rack::Builder.new do
      use OmniAuth::Test::PhonySession
      use OmniAuth::Strategies::MultiPassword do
        authenticator :one_test
        authenticator :two_test
      end
      run ->(env) { [404, {'Content-Type' => 'text/plain'}, [env['omniauth.auth']['uid'].to_s]] }
    end.to_app
  end

  it 'shows login FORM' do
    get '/auth/multipassword'

    expect(last_response.body).to include '<form'
  end

  it 'redirect on all failed strategies' do
    post '/auth/multipassword/callback', username: 'paul', password: 'wrong'

    expect(last_response).to be_redirect
    expect(last_response.headers['Location']).to eq '/auth/failure?message=invalid_credentials&strategy=multipassword'
  end

  it 'authenticates john' do
    post '/auth/multipassword/callback', username: 'john', password: 'secret'

    expect(last_response.body).to eq 'john'
  end

  it 'authenticates jane' do
    post '/auth/multipassword/callback', username: 'jane', password: '1234'

    expect(last_response.body).to eq 'jane'
  end
end
