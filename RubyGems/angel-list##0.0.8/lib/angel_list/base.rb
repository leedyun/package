module AngelList
  class Base
    attr_accessor :auth
    
    def initialize(auth)
      self.auth = auth
    end
    
    def parse(r)
      AngelList::Response.new(r).content
    end
    
    def get(url, options={})
      parse(self.auth.token.get(url, options))
    end
    
    def post(url, options={})
      parse(self.auth.token.post(url, options))
    end
    
    def delete(url, options={})
      parse(self.auth.token.delete(url, options))
    end
  end
end


