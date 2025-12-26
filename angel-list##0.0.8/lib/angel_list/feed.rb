module AngelList
  class Feed < Base
    def all(options={})
      get('https://api.angel.co/1/feed', options)
    end
    
    def find(id, options={})
      get('https://api.angel.co/1/feed/'+id.to_s, options)
    end
  end
end