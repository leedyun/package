module AngelList
  class Startup < Base
    def find(id)
      get('https://api.angel.co/1/startups/'+id.to_s)
    end
  end
end