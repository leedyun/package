require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestGetBlobHttpsUrl < Minitest::Test
  HOUR = 3600
  DAY = 24 * HOUR
  WEEK = 7 * DAY

  # This class posesses the test cases for the requests of Blob service.
  def setup
    Fog.mock!
    @mock_service = Fog::AzureRM::Storage.new(storage_account_credentials)
    Fog.unmock!

    @service = Fog::AzureRM::Storage.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @signature_client = @service.send(:signature_client, Minitest::Mock.new)

    @url = ApiStub::Requests::Storage::File.blob_https_url
    @token = ApiStub::Requests::Storage::File.blob_url_token
  end

  def test_get_blob_https_url_success
    mock_generate_uri = Minitest::Mock.new

    2.times do
      mock_generate_uri.expect(:call, URI.parse(@url), ['test_container/test_blob', {}, { encode: true }])
    end

    @blob_client.stub :generate_uri, mock_generate_uri do
      @signature_client.stub :generate_service_sas_token, @token do
        assert_equal "#{@url}?#{@token}", @service.get_blob_https_url('test_container', 'test_blob', Time.now.utc + 3600)
        assert_equal "#{@url}?#{@token}", @service.get_object_url('test_container', 'test_blob', Time.now.utc + 3600)
      end
    end
  end

  def test_get_blob_https_url_with_content_disposition
    mock_generate_uri = Minitest::Mock.new
    mock_generate_service_token = Minitest::Mock.new
    url_params = { content_disposition: 'attachment' }

    2.times do
      mock_generate_uri.expect(:call, URI.parse(@url), ['test_container/test_blob', {}, { encode: true }])
      mock_generate_service_token.expect(:call, @token) do |_relative_path, params|
        params[:service] == 'b' &&
          params[:resource] == 'b' &&
          params[:permissions] == 'r' &&
          params[:protocol] == 'https' &&
          params[:content_disposition] == url_params[:content_disposition]
      end
    end

    @blob_client.stub :generate_uri, mock_generate_uri do
      @signature_client.stub :generate_service_sas_token, mock_generate_service_token do
        assert_equal "#{@url}?#{@token}", @service.get_blob_https_url('test_container', 'test_blob', Time.now.utc + 3600, url_params)
        assert_equal "#{@url}?#{@token}", @service.get_object_url('test_container', 'test_blob', Time.now.utc + 3600, url_params)
      end
    end
  end

  def test_get_url_remove_trailing_periods_from_path_segments
    mock_generate_uri = Minitest::Mock.new
    mock_generate_service_token = Minitest::Mock.new

    2.times do
      mock_generate_uri.expect(:call, URI.parse(@url), ['.test0/..test1/...test2', {}, { encode: true }])
      mock_generate_service_token.expect(:call, @token) do |relative_path, _|
        relative_path == '.test0/..test1/...test2'
      end
    end

    @blob_client.stub :generate_uri, mock_generate_uri do
      @signature_client.stub :generate_service_sas_token, mock_generate_service_token do
        assert_equal "#{@url}?#{@token}", @service.get_blob_https_url('.test0.', '..test1../...test2...', Time.now.utc + 3600)
        assert_equal "#{@url}?#{@token}", @service.get_object_url('.test0.', '..test1../...test2...', Time.now.utc + 3600)
      end
    end
  end

  def test_get_blob_https_url_with_endpoint_success
    service = Fog::AzureRM::Storage.new(storage_account_credentials_with_endpoint)
    signature_client = service.send(:signature_client, Minitest::Mock.new)

    url = 'http://localhost:10000/mockaccount/test_container/test_blob'
    token = ApiStub::Requests::Storage::File.blob_url_token

    signature_client.stub :generate_service_sas_token, token do
      assert_equal "#{url}?#{token}", service.get_blob_https_url('test_container', 'test_blob', Time.now.utc + 3600)
      assert_equal "#{url}?#{token}", service.get_object_url('test_container', 'test_blob', Time.now.utc + 3600)
    end
  end

  def test_get_blob_https_url_with_domain_success
    service = Fog::AzureRM::Storage.new(storage_account_credentials_with_domain)
    signature_client = service.send(:signature_client, Minitest::Mock.new)

    url = 'https://mockaccount.test.example.com/test_container/test_blob'
    token = ApiStub::Requests::Storage::File.blob_url_token

    signature_client.stub :generate_service_sas_token, token do
      assert_equal "#{url}?#{token}", service.get_blob_https_url('test_container', 'test_blob', Time.now.utc + 3600)
      assert_equal "#{url}?#{token}", service.get_object_url('test_container', 'test_blob', Time.now.utc + 3600)
    end
  end

  def test_get_blob_https_url_with_managed_identity
    token_response = {
      'access_token' => 'fake_token',
      'expires_on' => (Time.now + 3600).to_i.to_s
    }

    stub_request(:get, "#{Fog::AzureRM::Identity::IDENTITY_ENDPOINT}?api-version=#{Fog::AzureRM::Identity::API_VERSION}&resource=https://storage.azure.com")
      .with(headers: { 'Metadata' => 'true' })
      .to_return(status: 200, body: token_response.to_json)

    service = Fog::AzureRM::Storage.new(storage_account_managed_identity)

    requested_expiry = Time.now + 60

    response = <<~MSG
      <UserDelegationKey>
          <SignedOid>f81d4fae-7dec-11d0-a765-00a0c91e6bf6</SignedOid>
          <SignedTid>72f988bf-86f1-41af-91ab-2d7cd011db47</SignedTid>
          <SignedStart>2024-09-19T00:00:00Z</SignedStart>
          <SignedExpiry>2024-09-26T00:00:00Z</SignedExpiry>
          <SignedService>b</SignedService>
          <SignedVersion>2020-02-10</SignedVersion>
          <Value>UDELEGATIONKEYXYZ....</Value>
          <SignedKey>rL7...ABC</SignedKey>
      </UserDelegationKey>
    MSG

    stub_request(:post, 'https://mockaccount.blob.core.windows.net?comp=userdelegationkey&restype=service')
      .to_return(status: 200, headers: { 'Content-Type': 'application/xml' }, body: response)

    url = service.get_blob_https_url('test_container', 'test_blob', requested_expiry)

    parsed = URI.parse(url)

    assert_equal 'https', parsed.scheme
    assert_equal 'mockaccount.blob.core.windows.net', parsed.host
    assert_equal '/test_container/test_blob', parsed.path

    params = parsed.query.split('&').to_h { |x| x.split('=') }

    assert_equal 'r', params['sp']
    assert_equal '2018-11-09', params['sv']
    assert_equal 'b', params['sr']
    assert_equal 'https', params['spr']
    assert_equal '2024-09-19T00%3A00%3A00Z', params['skt']
    assert_equal '2024-09-26T00%3A00%3A00Z', params['ske']
    assert_equal 'b', params['sks']
  end

  def test_get_blob_https_url_with_token_signer_success
    service = Fog::AzureRM::Storage.new(storage_account_credentials_with_token_signer)
    blob_client = service.instance_variable_get(:@blob_client)

    ref_time = Time.now

    stubbed_times = []
    requested_expiries = []
    expected_user_delegation_key_starts = []

    # initial request
    stubbed_times << ref_time
    requested_expiries << stubbed_times.last + 1 * HOUR
    expected_user_delegation_key_starts << stubbed_times.last

    # second request during expiry window
    stubbed_times << ref_time + 5.5 * DAY
    requested_expiries << stubbed_times.last + 1 * DAY
    # no additonal expected_user_delegation_key_starts

    # request extending past current expiry
    stubbed_times << ref_time + 6.5 * DAY
    requested_expiries << stubbed_times.last + 1 * DAY
    expected_user_delegation_key_starts << stubbed_times.last

    # second request within new expiry
    stubbed_times << ref_time + 10.5 * DAY
    requested_expiries << stubbed_times.last + 1 * DAY
    # no additional expected_user_delegation_key_starts

    user_delegation_key_starts = []
    mock_user_delegation_key = lambda do |start, expiry|
      user_delegation_key_starts << start
      assert_equal 1 * WEEK, expiry - start

      key = Azure::Storage::Common::Service::UserDelegationKey.new
      key.signed_start = "start-#{start.to_i}"
      key.signed_expiry = 'test-expiry'
      key.value = 'delegation-key'
      key
    end

    mock_new_signer = lambda do |token|
      assert_equal 'delegation-key', token
      mock_token_signer
    end

    requested_expiries.each do
      mock_token_signer.expect(:sign, 'test-signature', [/\Ar\n.+test_blob\n.+\nstart-\d+\ntest-expiry/m])
    end

    Time.stub :now, -> { stubbed_times.first } do
      blob_client.stub :get_user_delegation_key, mock_user_delegation_key do
        Azure::Core::Auth::Signer.stub :new, mock_new_signer do
          while (requested_expiry = requested_expiries.shift)
            url = service.get_blob_https_url('test_container', 'test_blob', requested_expiry)
            assert_match(/^#{Regexp.escape @url}.+&skt=start-#{user_delegation_key_starts.last.to_i}&.+&sig=test-signature/, url)

            stubbed_times.shift
          end
        end
      end
    end

    assert_equal expected_user_delegation_key_starts, user_delegation_key_starts
  end

  def test_get_blob_https_url_mock
    assert_equal "#{@url}?#{@token}", @mock_service.get_blob_https_url('test_container', 'test_blob', Time.now.utc + 3600)
    assert_equal "#{@url}?#{@token}", @mock_service.get_object_url('test_container', 'test_blob', Time.now.utc + 3600)
  end
end
