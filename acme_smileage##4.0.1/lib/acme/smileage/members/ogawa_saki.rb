# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class OgawaSaki < Base
        def initialize
          @family_name_ja = "小川"
          @first_name_ja = "紗季"
          @family_name_en = "Ogawa"
          @first_name_en = "Saki"
          @birthday = Date.new(1996, 11, 18)
          @blood_type = "A"
          @hometown = "埼玉"
          @emoticon = "|||s･ _･）"
          @nicknames = ["サキチィー"]
          @member_color = "Light Green"
          @generation = 1
          @join_date = Date.new(2009, 4, 4)
          @graduate_date = Date.new(2011, 8, 27)
          @blog_link = nil
          @twitter_accounts = []
        end
      end
    end
  end
end
