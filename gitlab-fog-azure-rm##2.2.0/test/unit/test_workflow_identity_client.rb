require File.expand_path '../test_helper', __dir__

class TestWorkflowIdentityClient < Minitest::Test
  def setup
    @options = { environment: 'AzureCloud' }
    @client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(@options)
  end

  def teardown
    ENV.delete('AZURE_TENANT_ID')
    ENV.delete('AZURE_CLIENT_ID')
    ENV.delete('AZURE_FEDERATED_TOKEN_FILE')
    ENV.delete('AZURE_AUTHORITY_HOST')
  end

  def test_initialize
    assert_equal 'https://storage.azure.com', @client.resource
    assert_equal 'https://login.microsoftonline.com', @client.authority
    assert_nil @client.tenant_id
    assert_nil @client.client_id
  end

  def test_fetch_credentials_success
    ENV['AZURE_TENANT_ID'] = 'fake_tenant_id'
    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = 'fake_token_file'

    @client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(@options)

    token_response = {
      'access_token' => 'fake_access_token',
      'expires_on' => (Time.now + 3600).to_i.to_s
    }

    File.stub :exist?, true do
      File.stub :readable?, true do
        File.stub :read, 'fake_oidc_token' do
          stub_request(:post, "#{@client.authority}/fake_tenant_id/oauth2/v2.0/token")
            .to_return(status: 200, body: token_response.to_json)

          credentials = @client.fetch_credentials

          assert_equal 'fake_access_token', credentials.token
          assert_instance_of Time, credentials.expires_at
        end
      end
    end
  end

  def test_fetch_credentials_failure
    ENV['AZURE_TENANT_ID'] = 'fake_tenant_id'
    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = 'fake_token_file'

    @client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(@options)

    File.stub :exist?, true do
      File.stub :readable?, true do
        File.stub :read, 'fake_oidc_token' do
          stub_request(:post, "#{@client.authority}/fake_tenant_id/oauth2/v2.0/token")
            .to_raise(Faraday::Error)

          assert_raises(Fog::AzureRM::Identity::BaseClient::FetchCredentialsError) do
            @client.fetch_credentials
          end
        end
      end
    end
  end

  def test_fetch_credentials_unauthorized
    ENV['AZURE_TENANT_ID'] = 'fake_tenant_id'
    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = 'fake_token_file'

    @client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(@options)

    File.stub :exist?, true do
      File.stub :readable?, true do
        File.stub :read, 'fake_oidc_token' do
          stub_request(:post, "#{@client.authority}/fake_tenant_id/oauth2/v2.0/token")
            .to_return(status: 403, body: '{"error":"invalid_client"}')

          assert_raises(Fog::AzureRM::Identity::BaseClient::FetchCredentialsError) { @client.fetch_credentials }
        end
      end
    end
  end

  def test_fetch_credentials_missing_env_vars
    ENV['AZURE_TENANT_ID'] = nil
    ENV['AZURE_CLIENT_ID'] = nil
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = nil

    assert_nil @client.fetch_credentials
  end

  def test_fetch_credentials_missing_token_file
    ENV['AZURE_TENANT_ID'] = 'fake_tenant_id'
    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = 'nonexistent_file'

    File.stub :exist?, false do
      assert_nil @client.fetch_credentials
    end
  end

  def test_authority
    ENV['AZURE_TENANT_ID'] = 'fake_tenant_id'
    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = 'fake_token_file'

    # Test with default AzureCloud environment
    client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(@options)
    assert_equal 'https://login.microsoftonline.com', client.authority
    assert_equal 'https://storage.azure.com', client.resource

    # Test with AzureUSGovernment environment
    gov_options = { environment: 'AzureUSGovernment' }
    gov_client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(gov_options)
    assert_equal 'https://login.microsoftonline.us', gov_client.authority
    assert_equal 'https://storage.azure.com', gov_client.resource

    # Test with AzureChina environment
    china_options = { environment: 'AzureChinaCloud' }
    china_client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(china_options)
    assert_equal 'https://login.chinacloudapi.cn', china_client.authority
    assert_equal 'https://storage.azure.com', china_client.resource

    # Test with AzureGermanCloud environment
    german_options = { environment: 'AzureGermanCloud' }
    german_client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(german_options)
    assert_equal 'https://login.microsoftonline.de', german_client.authority
    assert_equal 'https://storage.azure.com', german_client.resource
  end

  def test_authority_normalize
    ENV['AZURE_TENANT_ID'] = 'fake_tenant_id'
    ENV['AZURE_CLIENT_ID'] = 'fake_client_id'
    ENV['AZURE_FEDERATED_TOKEN_FILE'] = 'fake_token_file'
    ENV['AZURE_AUTHORITY_HOST'] = 'login.microsoftonline.com'

    # Test with default AzureCloud environment
    client = Fog::AzureRM::Identity::WorkflowIdentityClient.new(@options)
    assert_equal 'https://login.microsoftonline.com', client.authority
  end
end
