module AngelList
  class Config
    def self.options=(val)
      @@options = val
    end
    
    def self.options
      @@options
    end
  end
end