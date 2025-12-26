module AngelList
  class Path < Base
    def find(options)
      get('https://api.angel.co/1/paths', options)
    end
  end
end