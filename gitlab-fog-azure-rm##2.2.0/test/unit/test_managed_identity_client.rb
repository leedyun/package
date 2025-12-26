require File.expand_path '../test_helper', __dir__

class TestManagedIdentityClient < Minitest::Test
  def setup
    @options = { environment: 'AzureCloud' }
    @client = Fog::AzureRM::Identity::ManagedIdentityClient.new(@options)
  end

  def teardown
    ENV.delete('AZURE_CLIENT_ID')
    ENV.delete('IDENTITY_HEADER')
    ENV.delete('IDENTITY_ENDPOINT')
  end

  def test_initialize
    assert_equal 'https://storage.azure.com', @client.resource
  end

  def test_fetch_credentials_success
    token_response = {
      'access_token' => 'fake_token',
      'expires_on' => (Time.now + 3600).to_i.to_s
    }

    stub_request(:get, "#{Fog::AzureRM::Identity::IDENTITY_ENDPOINT}?api-version=#{Fog::AzureRM::Identity::API_VERSION}&resource=#{CGI.escape(@client.resource)}")
      .with(headers: { 'Metadata' => 'true' })
      .to_return(status: 200, body: token_response.to_json)

    credentials = @client.fetch_credentials

    assert_equal 'fake_token', credentials.token
    assert_instance_of Time, credentials.expires_at
  end

  def test_fetch_credentials_timeout
    stub_request(:get, "#{Fog::AzureRM::Identity::IDENTITY_ENDPOINT}?api-version=#{Fog::AzureRM::Identity::API_VERSION}&resource=#{CGI.escape(@client.resource)}")
      .with(headers: { 'Metadata' => 'true' })
      .to_raise(Faraday::Error)

    assert_raises(Fog::AzureRM::Identity::BaseClient::FetchCredentialsError) do
      @client.fetch_credentials
    end
  end

  def test_fetch_credentials_unauthorized
    stub_request(:get, "#{Fog::AzureRM::Identity::IDENTITY_ENDPOINT}?api-version=#{Fog::AzureRM::Identity::API_VERSION}&resource=#{CGI.escape(@client.resource)}")
      .with(headers: { 'Metadata' => 'true' })
      .to_return(status: 401)

    assert_raises(Fog::AzureRM::Identity::BaseClient::FetchCredentialsError) do
      @client.fetch_credentials
    end
  end

  def test_fetch_credentials_with_env_vars
    token_response = {
      'access_token' => 'fake_token',
      'expires_on' => (Time.now + 3600).to_i.to_s
    }

    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['IDENTITY_HEADER'] = 'fake_identity_header'
    ENV['IDENTITY_ENDPOINT'] = 'http://localhost:8080/metadata/identity/oauth2/token'

    stub_request(:get, "http://localhost:8080/metadata/identity/oauth2/token?api-version=2019-08-01&client_id=fake_client_id&resource=#{CGI.escape(@client.resource)}")
      .with(headers: { 'Metadata' => 'true', 'X-Identity-Header' => 'fake_identity_header' })
      .to_return(status: 200, body: token_response.to_json)

    credentials = @client.fetch_credentials

    assert_equal 'fake_token', credentials.token
    assert_instance_of Time, credentials.expires_at
  end
end
