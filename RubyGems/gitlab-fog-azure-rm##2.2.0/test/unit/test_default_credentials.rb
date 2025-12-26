require File.expand_path '../test_helper', __dir__

class TestDefaultCredentials < Minitest::Test
  def setup
    @options = { environment: 'AzureCloud' }
    @default_credentials = Fog::AzureRM::DefaultCredentials.new(@options)
  end

  def test_initialize
    assert_instance_of Fog::AzureRM::DefaultCredentials, @default_credentials
    assert_nil @default_credentials.instance_variable_get(:@credential_client)
    assert_nil @default_credentials.instance_variable_get(:@credentials)
  end

  def test_fetch_credentials_if_needed_with_no_credential_client
    @default_credentials.stub(:credential_client, nil) do
      assert_nil @default_credentials.fetch_credentials_if_needed
    end
  end

  def test_fetch_credentials_if_needed_with_credential_client
    mock_client = Minitest::Mock.new
    mock_client.expect :fetch_credentials_if_needed, 'fake_credentials'
    @default_credentials.instance_variable_set(:@credential_client, mock_client)

    assert_equal 'fake_credentials', @default_credentials.fetch_credentials_if_needed
    mock_client.verify
  end

  def test_credential_client_with_workflow_identity
    mock_workflow_client = Minitest::Mock.new
    mock_workflow_client.expect :fetch_credentials, 'fake_workflow_credentials'

    Fog::AzureRM::Identity::WorkflowIdentityClient.stub :new, mock_workflow_client do
      credentials = @default_credentials.send(:credential_client)
      assert_equal 'fake_workflow_credentials', credentials
    end

    mock_workflow_client.verify
  end

  def test_credential_client_with_managed_identity
    mock_workflow_client = Minitest::Mock.new
    mock_workflow_client.expect :fetch_credentials, nil

    mock_managed_client = Minitest::Mock.new
    mock_managed_client.expect :fetch_credentials, 'fake_managed_credentials'

    Fog::AzureRM::Identity::WorkflowIdentityClient.stub :new, mock_workflow_client do
      Fog::AzureRM::Identity::ManagedIdentityClient.stub :new, mock_managed_client do
        credentials = @default_credentials.send(:credential_client)
        assert_equal 'fake_managed_credentials', credentials
      end
    end

    mock_workflow_client.verify
    mock_managed_client.verify
  end

  def test_credential_client_with_failed_workflow_identity
    mock_workflow_client = Minitest::Mock.new
    def mock_workflow_client.fetch_credentials
      raise ::Fog::AzureRM::Identity::BaseClient::FetchCredentialsError, 'Failed to fetch credentials'
    end

    mock_managed_client = Minitest::Mock.new
    mock_managed_client.expect :fetch_credentials, 'fake_managed_credentials'

    Fog::AzureRM::Identity::WorkflowIdentityClient.stub :new, mock_workflow_client do
      Fog::AzureRM::Identity::ManagedIdentityClient.stub :new, mock_managed_client do
        credentials = @default_credentials.send(:credential_client)
        assert_equal 'fake_managed_credentials', credentials
      end
    end

    mock_workflow_client.verify
    mock_managed_client.verify
  end

  def test_credential_client_with_no_credentials
    mock_workflow_client = Minitest::Mock.new
    mock_workflow_client.expect :fetch_credentials, nil

    mock_managed_client = Minitest::Mock.new
    mock_managed_client.expect :fetch_credentials, nil

    Fog::AzureRM::Identity::WorkflowIdentityClient.stub :new, mock_workflow_client do
      Fog::AzureRM::Identity::ManagedIdentityClient.stub :new, mock_managed_client do
        assert_nil @default_credentials.send(:credential_client)
        assert_nil @default_credentials.instance_variable_get(:@credential_client)
      end
    end

    mock_workflow_client.verify
    mock_managed_client.verify
  end
end
