module AngelList
  class Tag < Base
    def find(id)
      get('https://api.angel.co/1/tags/'+id.to_s)
    end
    
    def children(id)
      get('https://api.angel.co/1/tags/'+id.to_s+'/children')
    end
    
    def parents(id)
      get('https://api.angel.co/1/tags/'+id.to_s+'/parents')
    end
  end
end