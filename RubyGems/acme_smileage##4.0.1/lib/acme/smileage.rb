require "date"

require "acme/smileage/members"
require "acme/smileage/discography"
require "acme/smileage/version"

module Acme
  class Smileage
    attr_reader :birthday, :homepage_link

    def initialize
      @birthday = Date.new(2009, 4, 4)
      @homepage_link = "http://s-mileage.jp"

      @members = Acme::Smileage::Members.new
      @discography = Acme::Smileage::Discography.new
    end

    def members(&block)
      if block
        @members.members.select(&block)
      else
        @members.members.dup
      end
    end

    def discography(&block)
      @discography.discography(&block)
    end

    def tracks(&block)
      @discography.tracks(&block)
    end

    def blogs(&block)
      members = block ? @members.select(&block) : @members
      members = members.select {|e| e.active? }
      members.map{|e| e.blog_link }.compact.uniq.map {|blog_link|
        Acme::Smileage::Blog::Ameblo.new(blog_link)
      }
    end

    def find_discography(name)
      @discography.find_discography(name)
    end

    def find_track(name)
      @discography.find_track(name)
    end

    def oricon_total_sales(&block)
      @discography.oricon_total_sales(&block)
    end
  end
end
