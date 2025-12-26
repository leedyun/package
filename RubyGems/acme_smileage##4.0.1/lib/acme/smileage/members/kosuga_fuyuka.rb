# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class KosugaFuyuka < Base
        def initialize
          @family_name_ja = "小数賀"
          @first_name_ja = "芙由香"
          @family_name_en = "Kosuga"
          @first_name_en = "Fuyuka"
          @birthday = Date.new(1997, 11, 19)
          @blood_type = "O"
          @hometown = "神奈川"
          @emoticon = "从´’_l ’从"
          @nicknames = ["ふ～ちゃん"]
          @member_color = "Orange"
          @generation = 2
          @join_date = Date.new(2011, 8, 14)
          @graduate_date = Date.new(2011, 9, 9)
          @blog_link = nil
          @twitter_accounts = []
        end
      end
    end
  end
end
