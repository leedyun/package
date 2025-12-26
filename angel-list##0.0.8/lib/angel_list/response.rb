require 'oauth2'

module AngelList
  class Response
    attr_accessor :content
    
    def initialize(response)
      self.content = AngelList::Tools.parse(response.response.env[:body].to_s)
      self.content
    end
  end
end