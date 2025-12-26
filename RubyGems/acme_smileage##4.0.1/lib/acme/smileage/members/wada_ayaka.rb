# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class WadaAyaka < Base
        def initialize
          @family_name_ja = "和田"
          @first_name_ja = "彩花"
          @family_name_en = "Wada"
          @first_name_en = "Ayaka"
          @birthday = Date.new(1994, 8, 1)
          @blood_type = "A"
          @hometown = "群馬"
          @emoticon = "川 ´‘ _‘||"
          @nicknames = ["あやちょ", "DAWA"]
          @member_color = "Blue"
          @generation = 1
          @join_date = Date.new(2009, 4, 4)
          @graduate_date = nil
          @blog_link = "http://ameblo.jp/wadaayaka/"
          @twitter_accounts = ["@ayakawada", "@smileage_715"]
        end
      end
    end
  end
end
