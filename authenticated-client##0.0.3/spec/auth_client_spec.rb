require 'spec_helper'

describe AuthenticatedClient::AuthenticatedClient do
  before :each do
  end

  it 'has a version number' do
    expect(AuthenticatedClient::VERSION).not_to be nil
  end

  context "when performing an authenticated request" do
    context "with a valid token" do
      it 'respond with a successful request' do
        @iut = AuthenticatedClient::AuthenticatedClient.new
        @iut.url = 'http://authentication-token-generator-service:9393/generate'
        @iut.token = 'test_ecosystem_token_for_auth_token_aaapi_authenticator_service'
        @iut.verb = :post
        @iut.parameters = {}
        @iut.body = {}
        @iut.auditing = nil

        response = @iut.request
        expect(response.code).to eq '200'
      end
    end
    context "with an invalid token" do
      it 'respond unauthorized' do
        @iut = AuthenticatedClient::AuthenticatedClient.new
        @iut.url = 'http://authentication-token-generator-service:9393/generate'
        @iut.token = 'invalid'
        @iut.verb = :post
        @iut.parameters = {}
        @iut.body = {}
        @iut.auditing = nil

        response = @iut.request
        expect(response.code).to eq '401'
      end
    end
  end
end
