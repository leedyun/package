# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class TakeuchiAkari < Base
        def initialize
          @family_name_ja = "竹内"
          @first_name_ja = "朱莉"
          @family_name_en = "Takeuchi"
          @first_name_en = "Akari"
          @birthday = Date.new(1997, 11, 23)
          @blood_type = "O"
          @hometown = "埼玉"
          @emoticon = "川´・ o ･ﾘ"
          @nicknames = ["タケちゃん"]
          @member_color = "Red"
          @generation = 2
          @join_date = Date.new(2011, 8, 14)
          @graduate_date = nil
          @blog_link = "http://ameblo.jp/smileage-submember/"
          @twitter_accounts = ["@smileage_newmem", "@akari_takeuchi", "@smileage_715"]
        end
      end
    end
  end
end
