require 'oauth2'

module AngelList
  class Auth
    attr_accessor :options, :token, :client
    
    def initialize(opts)
      self.options = Hashie::Mash.new
      self.options = self.options.merge(AngelList::Config.options) if AngelList::Config.methods.include? :options
      self.options = self.options.merge(opts)
      self.options = self.options.merge(:site => 'https://angel.co/') if self.options[:site] == nil
      self.client = get_client
      self
    end
    
    def redirect_url
      self.client.auth_code.authorize_url(:redirect_uri => self.options[:redirect_uri])
    end
    
    def get_client
      OAuth2::Client.new(self.options[:client_id], self.options[:client_secret], 
            :site => self.options[:site], 
            :authorize_url    => '/api/oauth/authorize',
            :token_url        => '/api/oauth/token')
    end
    
    def code(c)
      self.token = self.client.auth_code.get_token(c, :redirect_uri => self.options[:redirect_uri])
      self
    end
    
    def from_hash(token)
      self.token = OAuth2::AccessToken.new(self.client, token)
      self
    end
  end
end