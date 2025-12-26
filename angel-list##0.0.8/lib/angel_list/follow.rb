module AngelList
  class Follow < Base
    def new(options)
      post('https://api.angel.co/1/follows', options)
    end
    
    def destroy(options)
      delete('https://api.angel.co/1/follows', options)
    end
    
    def batch(array)
      get('https://api.angel.co/1/follows/batch?ids='+array.join(','))
    end
    
    def followers(id)
      get('https://api.angel.co/1/users/'+id.to_s+'/followers')
    end
    
    def followers_ids(id)
      get('https://api.angel.co/1/users/'+id.to_s+'/followers/ids')
    end
    
    def following(id, options={})
      get('https://api.angel.co/1/users/'+id.to_s+'/following', options)
    end
    
    def following_ids(id, options={})
      get('https://api.angel.co/1/users/'+id.to_s+'/following/ids', options)
    end
    
    def startup(id)
      get('https://api.angel.co/1/startups/'+id.to_s+'/followers')
    end
    
    def startup_follower_ids(id)
      get('https://api.angel.co/1/startups/'+id.to_s+'/followers/ids')
    end
  end
end