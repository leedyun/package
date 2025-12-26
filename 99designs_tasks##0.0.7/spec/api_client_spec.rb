require '99designs/tasks'
require 'support/vcr'

describe NinetyNine::Tasks::ApiClient do
  it "creates a task" do
    VCR.use_cassette('create_task') do

      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      task = api.create_task body: 'hello', urls: ['http://dn.ht/money.svg'], filenames: ['spec/support/sample.txt']

      expect(task[:body]).to match('hello')
    end
  end

  it "should raise AuthenticationError when apikey is incorrect" do
    VCR.use_cassette('create_task_invalid_apikey') do

      api = NinetyNine::Tasks::ApiClient.new('fakeapikey', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      expect {
        api.create_task body: 'hello', urls: ['http://dn.ht/money.svg']
      }.to raise_error(NinetyNine::AuthenticationError)
    end
  end

  it "should raise ValidationError when body is blank" do
    VCR.use_cassette('create_task_blank_body') do

      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      expect {
        api.create_task body: '', urls: ['http://dn.ht/money.svg']
      }.to raise_error(NinetyNine::ValidationError)
    end
  end

  it "should raise PaymentError when user is out of credits" do
    VCR.use_cassette('create_task_no_credits') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      expect {
        api.create_task body: 'hello', urls: ['http://dn.ht/money.svg']
      }.to raise_error(NinetyNine::PaymentError)
    end
  end

  it "gets a task" do
    VCR.use_cassette('get_task') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      task = api.get_task('84cc6f1d34d60f14d42389a0ae92740a')
      expect(task[:body]).to match('hello')
    end
  end

  it "gets a list of my tasks" do
    VCR.use_cassette('my_tasks') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      task = api.my_tasks(page: 2, per_page: 1)
      expect(task[:items]).not_to be_empty
    end
  end

  it "raises NotFoundError when taskid doesnt exist" do
    VCR.use_cassette('task_not_found') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      expect {
        api.get_task('fakeade6a144db4cdf680d89251bd7e2594c10b6')
      }.to raise_error(NinetyNine::NotFoundError)
    end
  end

  it "updates a task" do
    VCR.use_cassette('update_task') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      api.update_task('84cc6f1d34d60f14d42389a0ae92740a', body: 'updated')
      task = api.get_task('84cc6f1d34d60f14d42389a0ae92740a')
      expect(task[:body]).to match('updated')
    end
  end

  it "attaches files" do
    VCR.use_cassette('attach_files') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      api.attach_files('84cc6f1d34d60f14d42389a0ae92740a', urls: ['http://dn.ht/money.svg'], filenames: ['spec/support/sample.txt'])
      task = api.get_task('84cc6f1d34d60f14d42389a0ae92740a')
      expect(task[:attachments].length).to match(4)
    end
  end

  it "deletes an attachment" do
    VCR.use_cassette('delete_attachment') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      task = api.get_task('84cc6f1d34d60f14d42389a0ae92740a')
      api.delete_attachment('84cc6f1d34d60f14d42389a0ae92740a', task[:attachments][0][:id])
      task = api.get_task('84cc6f1d34d60f14d42389a0ae92740a')
      expect(task[:attachments].length).to match(3)
    end
  end

  it "posts a comment" do
    VCR.use_cassette('post_comment') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      api.post_comment('84cc6f1d34d60f14d42389a0ae92740a', 'hello')
    end
  end

  it "requests a revision" do
    VCR.use_cassette('request_revision') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      api.request_revision('84cc6f1d34d60f14d42389a0ae92740a', 13, 'other', 'Can I have it in pdf too please?')
    end
  end

  it "approves a delivery" do
    VCR.use_cassette('approve_delivery') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      api.approve_delivery('84cc6f1d34d60f14d42389a0ae92740a', 14)
    end
  end

  it "raises InvalidStateError when requesting revision on approved delivery" do
    VCR.use_cassette('request_revision_approve_delivery') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      expect {
        api.request_revision('84cc6f1d34d60f14d42389a0ae92740a', 14, 'other', 'Is this too late?')
      }.to raise_error(NinetyNine::InvalidStateError)
    end
  end

  it "raises generic ApiError when server returns internal server error" do
    VCR.use_cassette('server_having_problems') do
      api = NinetyNine::Tasks::ApiClient.new('xyzzy', base_url: 'http://api.99designs.com.dockervm:49881/tasks/v1')

      expect {
        api.get_task('84cc6f1d34d60f14d42389a0ae92740a')
      }.to raise_error(NinetyNine::ApiError)
    end
  end



end
