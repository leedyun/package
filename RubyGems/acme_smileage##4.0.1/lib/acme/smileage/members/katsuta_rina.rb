# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class KatsutaRina < Base
        def initialize
          @family_name_ja = "勝田"
          @first_name_ja = "里奈"
          @family_name_en = "Katsuta"
          @first_name_en = "Rina"
          @birthday = Date.new(1998, 4, 6)
          @blood_type = "A"
          @hometown = "東京"
          @emoticon = "ﾘﾅp´ v｀)"
          @nicknames = ["りなぷ～"]
          @member_color = "Yellow"
          @generation = 2
          @join_date = Date.new(2011, 8, 14)
          @graduate_date = nil
          @blog_link = "http://ameblo.jp/smileage-submember/"
          @twitter_accounts = ["@smileage_newmem", "@smileage_715"]
        end
      end
    end
  end
end
