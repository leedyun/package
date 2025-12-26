module AngelList
  class Message < Base
    def new(options)
      post('https://api.angel.co/1/paths', options)
    end
    
    def thread(thread_id)
      get('https://api.angel.co/1/messages/'+thread_id.to_s)
    end
    
    def all(view=:inbox)
      get('https://api.angel.co/1/messages', {:view => view})
    end
  end
end