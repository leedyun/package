module AngelList
  class StartupRole < Base
    def find(startup_id)
      get('https://api.angel.co/1/startup_roles?startup_id='+startup_id.to_s)
    end
  end
end