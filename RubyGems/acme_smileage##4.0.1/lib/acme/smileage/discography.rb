# -*- encoding: utf-8 -*-

require "acme/smileage/utils/matcher"
require "acme/smileage/discography/albums"
require "acme/smileage/discography/tracks"

module Acme
  class Smileage
    class Discography
      def initialize
        album Acme::Smileage::Discography::Albums::Amanojaku
        album Acme::Smileage::Discography::Albums::AsuhaDateNanoniImasuguKoeGaKikitai
        album Acme::Smileage::Discography::Albums::Sukichan
        album Acme::Smileage::Discography::Albums::OtonaNiNarutteMuzukashii
        album Acme::Smileage::Discography::Albums::Yumemiru15sai
        album Acme::Smileage::Discography::Albums::Yumemiru15saiPaxJaponicaGrooveRemix
        album Acme::Smileage::Discography::Albums::GambaranakutemoEenende
        album Acme::Smileage::Discography::Albums::GambaranakutemoEenendeTopnudeRemixVersion01
        album Acme::Smileage::Discography::Albums::OnajiJikyuuDeHatarakuTomodachiNoBijinMama
        album Acme::Smileage::Discography::Albums::OnajiJikyuuDeHatarakuTomodachiNoBijinMamaRemixType1
        album Acme::Smileage::Discography::Albums::WaruGaki1
        album Acme::Smileage::Discography::Albums::Shortcut
        album Acme::Smileage::Discography::Albums::KoiNiBooingBoo
        album Acme::Smileage::Discography::Albums::UchoutenLove
        album Acme::Smileage::Discography::Albums::ShortcutRemixver
        album Acme::Smileage::Discography::Albums::UchoutenLoverocketmanMix
        album Acme::Smileage::Discography::Albums::Tachiagirl
        album Acme::Smileage::Discography::Albums::PleaseMinisukaPostWoman
        album Acme::Smileage::Discography::Albums::ChotoMateKudasai
        album Acme::Smileage::Discography::Albums::Dotbikini
        album Acme::Smileage::Discography::Albums::SmleageBestAlbumComplete1
        album Acme::Smileage::Discography::Albums::SukiyoJunjouHankouki
        album Acme::Smileage::Discography::Albums::Samuine
        album Acme::Smileage::Discography::Albums::TabidachiNoHaruGaKita
        album Acme::Smileage::Discography::Albums::SmileSensation
        album Acme::Smileage::Discography::Albums::AtarashiiWatashiniNare_Yattaruchan
        album Acme::Smileage::Discography::Albums::Eeka_Iiyatsu
        album Acme::Smileage::Discography::Albums::MysteryNight_EighteenEmotion

        initialize_tracks
      end

      def discography(&block)
        if block
          @albums.select(&block)
        else
          @albums.dup
        end
      end

      def tracks(&block)
        if block
          @tracks.select(&block)
        else
          @tracks.dup
        end
      end

      def find_discography(name)
        find("Discography", name, @albums)
      end

      def find_track(name)
        find("Track", name, @tracks)
      end

      def oricon_total_sales(&block)
        albums = block ? @albums.select(&block) : @albums
        albums.inject(0) {|sum,e|
          if e.oricon
            sum + e.oricon.total_sales
          else
            sum
          end
        }
      end

      private

      def find(label, name, targets)
        matcher = Acme::Smileage::Utils::Matcher.new(name.encode("UTF-8"))
        canon_name = matcher.match(targets.map {|e| names(e) }.flatten)
        raise ArgumentError, "#{label} not found: #{name}" unless canon_name
        targets.find {|e| names(e).include?(canon_name) }
      end

      def names(obj)
        [obj.name, obj.name_romaji] | obj.nicknames
      end

      def initialize_tracks
        @tracks = @albums.sort_by {|e| e.release_date }.map{|e| e.tracks }.flatten.uniq
      end

      def album(album_class)
        @albums ||= []
        @albums << album_class.instance
      end
    end
  end
end
