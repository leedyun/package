# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class MaedaYuuka < Base
        def initialize
          @family_name_ja = "前田"
          @first_name_ja = "憂佳"
          @family_name_en = "Maeda"
          @first_name_en = "Yuuka"
          @birthday = Date.new(1994, 12, 24)
          @blood_type = "B"
          @hometown = "千葉"
          @emoticon = "川*´ ｃ｀)"
          @nicknames = ["ゆうかりん"]
          @member_color = "Pink"
          @generation = 1
          @join_date = Date.new(2009, 4, 4)
          @graduate_date = Date.new(2011, 12, 31)
          @blog_link = nil
          @twitter_accounts = []
        end
      end
    end
  end
end
