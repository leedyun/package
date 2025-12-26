# -*- encoding: utf-8 -*-

require "acme/smileage/members/base"

module Acme
  class Smileage
    class Members
      class FukudaKanon < Base
        def initialize
          @family_name_ja = "福田"
          @first_name_ja = "花音"
          @family_name_en = "Fukuda"
          @first_name_en = "Kanon"
          @birthday = Date.new(1995, 3, 12)
          @blood_type = "A"
          @hometown = "埼玉"
          @emoticon = "从*・ェ・ﾘ"
          @nicknames = ["かにょん"]
          @member_color = "Purple"
          @generation = 1
          @join_date = Date.new(2009, 4, 4)
          @graduate_date = nil
          @blog_link = "http://ameblo.jp/kanon-fukuda/"
          @twitter_accounts = ["@kanonfukuda", "@smileage_715"]
        end
      end
    end
  end
end
