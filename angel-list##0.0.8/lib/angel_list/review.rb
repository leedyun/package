module AngelList
  class Review < Base
    def find(user_id)
      get('https://api.angel.co/1/reviews?user_id='+user_id)
    end
  end
end