# -*- encoding: utf-8 -*-

require "date"

require "minitest_helper"

class Acme::TestTrack < Minitest::Test
  def test_tracks
    s = ::Acme::Smileage.new

    a = s.tracks.find {|e| e.name =~ /クレームブリュレ/ }
    assert_equal "サンキュ！ クレームブリュレの友情", a.name
    assert_equal "thank you! creme brulee no yuujou", a.name_romaji
    assert_equal ["クレームブリュレ"], a.nicknames
    assert_equal ["亜伊林"], a.lyricists
    assert_equal ["つんく♂"], a.composers
    assert_equal ["高橋諭一"], a.arrangers
    assert_equal [], a.youtube_links
    assert_equal [{:title => "夢見る 15歳", :link => "https://itunes.apple.com/jp/album/id372351545"}], a.itunes_links
    assert_equal false, a.cover?
    assert_equal false, a.remix?
    assert_equal [2010, 42, 49.0, 31], a.hpma.to_a
    assert_equal 230, a.play_time
  end

  def test_tracks_cover
    s = ::Acme::Smileage.new

    a = s.tracks.find {|e| e.name =~ /ちょこっと/ }
    assert_equal "ちょこっとLOVE", a.name
    assert_equal "chokotto love", a.name_romaji
    assert_equal ["ちょこラブ", "ちょこLOVE"], a.nicknames
    assert_equal ["鈴木俊介"], a.arrangers
    assert_equal [], a.youtube_links
    assert_equal [{:title => "同じ時給で働く友達の美人ママ", :link => "https://itunes.apple.com/jp/album/id390851470"}], a.itunes_links
    assert_equal true, a.cover?
    assert_equal false, a.remix?
    assert_equal [2010, 121, 4.0, 3], a.hpma.to_a
    assert_equal 243, a.play_time
  end

  def test_tracks_remix
    s = ::Acme::Smileage.new

    a = s.tracks.find {|e| e.name =~ /激萌え/ }
    assert_equal "スマイレージ シングルス 激萌えリミックス", a.name
    assert_equal "smileage singles gekimoe remix", a.name_romaji
    assert_equal [], a.nicknames
    assert_equal ["田中直"], a.arrangers
    assert_equal [], a.youtube_links
    assert_equal [{:title => "タチアガール", :link => "https://itunes.apple.com/jp/album/id464723016"}], a.itunes_links
    assert_equal false, a.cover?
    assert_equal true, a.remix?
    assert_equal [2011, 121, 4.5, 3], a.hpma.to_a
    assert_equal 336, a.play_time
  end
end
