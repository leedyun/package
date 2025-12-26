module RegisterGameSpecHelper

  def stubbed_request 
    stub_request(:post, "http://battle.platform45.com/register").with(:body => "{\"name\":\"henry@thehthornton.com\",\"email\":\"henry thornton\"}", :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'58', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => {:id => 100, :x => 3, :y => 2}.to_json, :headers => {})
  end

end
