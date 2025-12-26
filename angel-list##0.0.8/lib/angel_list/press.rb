module AngelList
  class Press < Base
    def find(startup_id)
      get('https://api.angel.co/1/press?startup_id='+startup_id.to_s)
    end
  end
end