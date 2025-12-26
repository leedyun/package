# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

describe OmniAuth::MultiPassword::Base do # rubocop:disable RSpec/SpecFilePathFormat  subject { strategy }
  let(:app) { instance_double(Proc) }
  let(:strategy) do
    OmniAuth::Strategies::OneTest.new(app, *args, &block)
  end
  let(:args) { [] }
  let(:block) { nil }

  describe '#username_id' do
    subject(:username_id) { strategy.username_id }

    it 'defaults to :username' do
      expect(username_id).to eq :username
    end

    context 'when configured' do
      let(:args) { [{fields: %i[user pass]}] }

      it { is_expected.to eq :user }
    end
  end

  describe '#password_id' do
    subject(:password_id) { strategy.password_id }

    it 'defaults to :password' do
      expect(password_id).to eq :password
    end

    context 'when configured' do
      let(:args) { [{fields: %i[user pass]}] }

      it { is_expected.to eq :pass }
    end
  end

  describe 'single strategy' do
    include Rack::Test::Methods

    let(:app) do
      Rack::Builder.new do
        use OmniAuth::Test::PhonySession
        use OmniAuth::Strategies::OneTest
        map '/app-ok' do
          run ->(env) { [200, {'Content-Type' => 'text/plain'}, ['OK']] }
        end
        run ->(env) { [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
      end.to_app
    end

    it 'shows login FORM' do
      get '/auth/onetest'

      expect(last_response.body).to include '<form'
    end

    it 'redirect on wrong password' do
      post '/auth/onetest/callback', username: 'john', password: 'wrong'
      expect(last_response).to be_redirect
      expect(last_response.headers['Location']).to eq '/auth/failure?message=invalid_credentials&strategy=onetest'
    end

    it 'authenticates john with correct password' do
      post '/auth/onetest/callback', username: 'john', password: 'secret'
      expect(last_response.body).to eq 'true'
    end

    it 'shows app page' do
      get '/app-ok'
      expect(last_response.body).to eq 'OK'
    end
  end
end
