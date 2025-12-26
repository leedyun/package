# -*- encoding: utf-8 -*-

require "date"

require "minitest_helper"

class Acme::TestAlbum < Minitest::Test
  def test_single
    s = ::Acme::Smileage.new

    a = s.discography.find {|e| e.name =~ /夢見る/ }
    assert_equal "夢見る 15歳", a.name
    assert_equal "yumemiru 15sai", a.name_romaji
    assert_equal Date.new(2010, 5, 26), a.release_date
    assert_equal 2010, a.release_year
    assert_equal [20438, 24936, 5, 4], a.oricon.to_a
    assert_equal [8494, 8494, 17, 1], a.soundscan.to_a

    artwork_links = [
      {
        :title => "夢見る 15歳 【通常盤】",
        :link => "http://s-mileage.jp/discography/obj/img/000/009/100517-1512_01l.jpg",
      },
      {
        :title => "夢見る 15歳 【初回生産限定盤A】",
        :link => "http://s-mileage.jp/discography/obj/img/000/009/100517-1512_02l.jpg",
      },
      {
        :title => "夢見る 15歳 【初回生産限定盤B】",
        :link => "http://s-mileage.jp/discography/obj/img/000/009/100517-1512_03l.jpg",
      },
    ]
    assert_equal artwork_links, a.artwork_links

    tracks = []
    tracks << Acme::Smileage::Discography::Tracks::Yumemiru15sai.instance
    tracks << Acme::Smileage::Discography::Tracks::ThankYouCremeBruleeNoYuujou.instance
    assert_equal tracks, a.tracks

    assert_equal true, a.single?
    assert_equal false, a.album?
    assert_equal false, a.best_album?
    assert_equal false, a.original_album?
    assert_equal true, a.major?
    assert_equal false, a.indies?
    assert_equal false, a.download_only?
  end

  def test_indies
    s = ::Acme::Smileage.new

    a = s.discography.find {|e| e.name =~ /ぁまのじゃく/ }
    assert_equal "ぁまのじゃく", a.name
    assert_equal "amanojaku", a.name_romaji
    assert_equal Date.new(2009, 6, 7), a.release_date
    assert_equal 2009, a.release_year
    assert_equal [0, 0, 0, 0], a.oricon.to_a
    assert_equal [0, 0, 0, 0], a.soundscan.to_a
    artwork_links = [
      {
        :title => "ぁまのじゃく",
        :link => "http://s-mileage.jp/discography/obj/img/000/012/100922-1209_01l.jpg",
      },
    ]
    assert_equal artwork_links, a.artwork_links

    tracks = []
    tracks << Acme::Smileage::Discography::Tracks::Amanojaku.instance
    assert_equal tracks, a.tracks

    assert_equal true, a.single?
    assert_equal false, a.album?
    assert_equal false, a.best_album?
    assert_equal false, a.original_album?
    assert_equal false, a.major?
    assert_equal true, a.indies?
    assert_equal false, a.download_only?
  end

  def test_download_only
    s = ::Acme::Smileage.new

    a = s.discography.find {|e| e.name =~ /PAX JAPONICA/ }
    assert_equal "夢見る 15歳 (PAX JAPONICA GROOVE REMIX)", a.name
    assert_equal "yumemiru 15sai (pax japonica groove remix)", a.name_romaji
    assert_equal Date.new(2010, 6, 18), a.release_date
    assert_equal 2010, a.release_year
    artwork_links = [
      {
        :title => "夢見る 15歳 (PAX JAPONICA GROOVE REMIX)",
        :link => "http://s-mileage.jp/discography/obj/img/000/032/100709-1334_01l.jpg",
      },
    ]
    assert_equal artwork_links, a.artwork_links

    tracks = []
    tracks << Acme::Smileage::Discography::Tracks::Yumemiru15saiPaxJaponicaGrooveRemix.instance
    assert_equal tracks, a.tracks

    assert_equal false, a.single?
    assert_equal false, a.album?
    assert_equal false, a.best_album?
    assert_equal false, a.original_album?
    assert_equal true, a.major?
    assert_equal false, a.indies?
    assert_equal true, a.download_only?
  end

  def test_album
    s = ::Acme::Smileage.new

    a = s.discography.find {|e| e.name =~ /悪ガキ/ }
    assert_equal "悪ガキッ①", a.name
    assert_equal "waru gaki (1)", a.name_romaji
    assert_equal Date.new(2010, 12, 8), a.release_date
    assert_equal 2010, a.release_year
    assert_equal [8905, 11848, 18, 5], a.oricon.to_a
    assert_equal [0, 0, 0, 0], a.soundscan.to_a

    artwork_links = [
      {
        :title => "悪ガキッ① 【通常盤】",
        :link => "http://s-mileage.jp/discography/obj/img/000/047/101118-1624_01l.jpg",
      },
      {
        :title => "悪ガキッ① 【初回生産限定盤】",
        :link => "http://s-mileage.jp/discography/obj/img/000/047/101118-1624_02l.jpg",
      },
    ]
    assert_equal artwork_links, a.artwork_links

    tracks = []
    tracks << Acme::Smileage::Discography::Tracks::OnajiJikyuuDeHatarakuTomodachiNoBijinMama.instance
    tracks << Acme::Smileage::Discography::Tracks::Odorouyo.instance
    tracks << Acme::Smileage::Discography::Tracks::OnnaBakariNoNichiyoubi.instance
    tracks << Acme::Smileage::Discography::Tracks::Yumemiru15sai.instance
    tracks << Acme::Smileage::Discography::Tracks::ShootingStar.instance
    tracks << Acme::Smileage::Discography::Tracks::GambaranakutemoEenende.instance
    tracks << Acme::Smileage::Discography::Tracks::Sukichan.instance
    tracks << Acme::Smileage::Discography::Tracks::GakkyuuIinchou.instance
    tracks << Acme::Smileage::Discography::Tracks::ShikkariShiteyoMou.instance
    tracks << Acme::Smileage::Discography::Tracks::OtonaNiNarutteMuzukashii.instance
    tracks << Acme::Smileage::Discography::Tracks::AsuhaDateNanoniImasuguKoeGaKikitai.instance
    tracks << Acme::Smileage::Discography::Tracks::Amanojaku.instance
    assert_equal tracks, a.tracks

    assert_equal false, a.single?
    assert_equal true, a.album?
    assert_equal false, a.best_album?
    assert_equal true, a.original_album?
    assert_equal true, a.major?
    assert_equal false, a.indies?
    assert_equal false, a.download_only?
  end

  def test_best_album
    s = ::Acme::Smileage.new

    a = s.discography.find {|e| e.name =~ /ベスト/ }
    assert_equal "スマイレージ ベストアルバム完全版①", a.name
    assert_equal "smleage best album complete (1)", a.name_romaji
    assert_equal [], a.nicknames
    assert_equal Date.new(2012, 5, 30), a.release_date
    assert_equal [6339, 8095, 13, 3], a.oricon.to_a
    assert_equal [0, 0, 0, 0], a.soundscan.to_a
    artwork_links = [
      {
        :title => "スマイレージ ベストアルバム完全版① 【通常盤】",
        :link => "http://s-mileage.jp/discography/obj/img/000/114/120502-2111_01l.jpg",
      },
      {
        :title => "スマイレージ ベストアルバム完全版① 【初回生産限定盤】",
        :link => "http://s-mileage.jp/discography/obj/img/000/114/120502-2111_02l.jpg",
      },
    ]
    assert_equal artwork_links, a.artwork_links

    tracks = []
    tracks << Acme::Smileage::Discography::Tracks::Dotbikini.instance
    tracks << Acme::Smileage::Discography::Tracks::ChotoMateKudasai.instance
    tracks << Acme::Smileage::Discography::Tracks::PleaseMinisukaPostWoman.instance
    tracks << Acme::Smileage::Discography::Tracks::Tachiagirl.instance
    tracks << Acme::Smileage::Discography::Tracks::UchoutenLove.instance
    tracks << Acme::Smileage::Discography::Tracks::KoiNiBooingBoo.instance
    tracks << Acme::Smileage::Discography::Tracks::Shortcut.instance
    tracks << Acme::Smileage::Discography::Tracks::OnajiJikyuuDeHatarakuTomodachiNoBijinMama.instance
    tracks << Acme::Smileage::Discography::Tracks::GambaranakutemoEenende.instance
    tracks << Acme::Smileage::Discography::Tracks::Yumemiru15sai.instance
    tracks << Acme::Smileage::Discography::Tracks::OtonaNiNarutteMuzukashii.instance
    tracks << Acme::Smileage::Discography::Tracks::Sukichan.instance
    tracks << Acme::Smileage::Discography::Tracks::AsuhaDateNanoniImasuguKoeGaKikitai.instance
    tracks << Acme::Smileage::Discography::Tracks::Amanojaku.instance
    tracks << Acme::Smileage::Discography::Tracks::KiiroiJitenshaToSandwich.instance
    assert_equal tracks, a.tracks

    assert_equal false, a.single?
    assert_equal true, a.album?
    assert_equal true, a.best_album?
    assert_equal false, a.original_album?
    assert_equal true, a.major?
    assert_equal false, a.indies?
    assert_equal false, a.download_only?
  end
end
