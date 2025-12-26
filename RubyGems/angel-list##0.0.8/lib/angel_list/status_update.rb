module AngelList
  class StatusUpdate < Base
    def new(options)
      post('https://api.angel.co/1/status_updates', :params => options)
    end
    
    def destroy(id)
      delete('https://api.angel.co/1/status_updates/'+id.to_s)
    end
    
    def find(options)
      get('https://api.angel.co/1/status_updates', options)
    end
  end
end