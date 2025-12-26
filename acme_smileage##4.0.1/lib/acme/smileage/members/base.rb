require "date"

require "acme/smileage/blog/ameblo"

module Acme
  class Smileage
    class Members
      class Base
        attr_reader :family_name_ja, :first_name_ja
        attr_reader :family_name_en, :first_name_en
        attr_reader :birthday, :blood_type, :hometown
        attr_reader :emoticon, :nicknames, :member_color, :blog_link, :twitter_accounts
        attr_reader :generation, :join_date, :graduate_date

        alias :nick :nicknames      # compat for Acme::MomoiroClover
        alias :color :member_color  # ditto

        def name_ja
          self.family_name_ja + self.first_name_ja
        end

        def name_en
          self.first_name_en + " " + self.family_name_en
        end
        alias :name :name_en

        def age(date=nil)
          date ||= Date.today
          a = date.strftime("%Y%m%d").to_i
          b = self.birthday.strftime("%Y%m%d").to_i
          (a - b) / 10000
        end

        def active?(date=nil)
          date ||= Date.today
          if self.graduate_date
            self.join_date <= date and date <= self.graduate_date
          else
            self.join_date <= date
          end
        end

        def graduated?(date=nil)
          return false unless self.graduate_date

          date ||= Date.today
          self.graduate_date < date
        end

        def blog
          @blog ||= Acme::Smileage::Blog::Ameblo.new(self.blog_link, self.family_name_en)
        end
      end
    end
  end
end
