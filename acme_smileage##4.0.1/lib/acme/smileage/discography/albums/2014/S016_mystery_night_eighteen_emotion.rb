# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class MysteryNight_EighteenEmotion < Base
          include Singleton

          def initialize
            @name = "ミステリーナイト！／エイティーン エモーション"
            @name_romaji = "mystery night!/eighteen emotion"
            @nicknames = ["ミスナイ", "エイエモ", "18エモ"]
            @release_date = Date.new(2014, 4, 30)
            @oricon = Sales.records(
              { :week => 1, :sales => 34340, :rank =>   2 },
              { :week => 2, :sales =>  1047, :rank =>  56 },
              { :week => 3, :sales =>   416, :rank => 116 },
              # 4 週目はランク外
              { :week => 5, :sales =>   813, :rank =>  81 },
            )
            @soundscan = Sales.new(6921 + 6256, 6921 + 6256, 12, 1) # http://www.phileweb.com/ranking/cd-top20/1830.html
            @discography_link = "http://s-mileage.jp/discography/detail_00186/"
            @artwork_links = [
              {
                :title => "ミステリーナイト！／エイティーン エモーション 【通常盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/186/140409-1814_01l.jpg",
              },
              {
                :title => "ミステリーナイト！／エイティーン エモーション 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/186/140409-1814_02l.jpg",
              },
              {
                :title => "ミステリーナイト！／エイティーン エモーション 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/186/140409-1814_03l.jpg",
              },
              {
                :title => "ミステリーナイト！／エイティーン エモーション 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/186/140409-1814_04l.jpg",
              },
              {
                :title => "ミステリーナイト！／エイティーン エモーション 【通常盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/186/140409-1814_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::MysteryNight
            track Acme::Smileage::Discography::Tracks::EighteenEmotion
          end
        end
      end
    end
  end
end
