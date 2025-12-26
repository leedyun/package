module AngelList
  class Search < Base
    def find(options)
      get('https://api.angel.co/1/search', options)
    end
  end
end