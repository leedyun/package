module AngelList
  class User < Base
    def me
      get('https://api.angel.co/1/me')
    end
    
    def find(id)
      get('https://api.angel.co/1/users/'+id.to_s)
    end
    
    def batch(array=[])
      get('https://api.angel.co/1/users/batch?ids='+array.join(','))
    end
    
    def search(string)
      get('https://api.angel.co/1/users/search?slug='+URI.escape(string))
    end
  end
end