module AngelList
  class Job < Base
    
    def all
      get('https://api.angel.co/1/jobs')
    end
    
    def find(id)
      get('https://api.angel.co/1/jobs/'+id.to_s)
    end
    
    def startup(id)
      get('https://api.angel.co/startups/'+id.to_s+'/jobs')
    end
    
    def tag(tag_id)
      get('https://api.angel.co/1/tags/'+tag_id.to_s+'/jobs')
    end
  end
end