# -*- encoding: utf-8 -*-

require "date"

require "minitest_helper"

class Acme::TestSmileage < Minitest::Test
  def test_version_number
    refute_nil ::Acme::Smileage::VERSION
  end

  def test_member_invalid_type
    s = ::Acme::Smileage.new
    assert_raises(ArgumentError) { s.members(:hoge) }
  end

  def test_member_all
    s = ::Acme::Smileage.new
    assert_equal ["Ayaka", "Yuuka", "Kanon", "Saki", "Kana", "Fuyuka", "Akari", "Rina", "Meimi"], s.members.map{|e| e.first_name_en }
  end

  def test_member_active
    s = ::Acme::Smileage.new
    assert_equal ["Ayaka", "Kanon", "Kana", "Akari", "Rina", "Meimi"], s.members {|e| e.active? }.map{|e| e.first_name_en }
  end

  def test_member_graduate
    s = ::Acme::Smileage.new
    assert_equal ["Yuuka", "Saki", "Fuyuka"], s.members {|e| e.graduated? }.map{|e| e.first_name_en }
  end

  def test_member_date
    s = ::Acme::Smileage.new

    assert_equal ["Ayaka", "Yuuka", "Kanon", "Saki"], s.members {|e| e.active?(Date.new(2011, 8, 13)) }.map{|e| e.first_name_en }
    assert_equal ["Ayaka", "Yuuka", "Kanon", "Saki", "Kana", "Fuyuka", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2011, 8, 14)) }.map{|e| e.first_name_en }

    assert_equal ["Ayaka", "Yuuka", "Kanon", "Saki", "Kana", "Fuyuka", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2011, 8, 27)) }.map{|e| e.first_name_en }
    assert_equal ["Ayaka", "Yuuka", "Kanon", "Kana", "Fuyuka", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2011, 8, 28)) }.map{|e| e.first_name_en }

    assert_equal ["Ayaka", "Yuuka", "Kanon", "Kana", "Fuyuka", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2011, 9, 9)) }.map{|e| e.first_name_en }
    assert_equal ["Ayaka", "Yuuka", "Kanon", "Kana", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2011, 9, 10)) }.map{|e| e.first_name_en }

    assert_equal ["Ayaka", "Yuuka", "Kanon", "Kana", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2011, 12, 31)) }.map{|e| e.first_name_en }
    assert_equal ["Ayaka", "Kanon", "Kana", "Akari", "Rina", "Meimi"], s.members {|e| e.active?(Date.new(2012, 1, 1)) }.map{|e| e.first_name_en }
  end

  def test_member_select
    s = ::Acme::Smileage.new

    assert_equal ["Ayaka", "Yuuka", "Kanon", "Saki"], s.members.select {|e| e.generation == 1 }.map{|e| e.first_name_en }
    assert_equal ["Kana", "Fuyuka", "Akari", "Rina", "Meimi"], s.members.select {|e| e.generation == 2 }.map{|e| e.first_name_en }
    assert_equal ["Kana", "Akari", "Rina", "Meimi"], s.members.select {|e| e.generation == 2 && e.active? }.map{|e| e.first_name_en }

    assert_equal ["Ayaka", "Meimi"], s.members.select {|e| e.hometown == "群馬" }.map{|e| e.first_name_en }
    assert_equal ["Kanon", "Saki", "Akari"], s.members.select {|e| e.hometown == "埼玉" }.map{|e| e.first_name_en }

    assert_equal ["Ayaka", "Kanon", "Saki", "Kana", "Rina"], s.members.select {|e| e.blood_type == "A" }.map{|e| e.first_name_en }
    assert_equal ["Yuuka"], s.members.select {|e| e.blood_type == "B" }.map{|e| e.first_name_en }
  end

  def test_member_sort_by
    s = ::Acme::Smileage.new
    assert_equal ["Akari", "Ayaka", "Fuyuka", "Kana", "Kanon", "Meimi", "Rina", "Saki", "Yuuka"], s.members.sort_by {|e| e.name }.map{|e| e.first_name_en }
  end

  def test_discography
    s = ::Acme::Smileage.new

    assert_equal 28, s.discography.length

    # discography に直接ブロック指定してフィルタ
    assert_equal 4, s.discography {|e| e.indies? }.length
    assert_equal 24, s.discography {|e| e.major? }.length

    assert_equal 3, s.discography {|e| e.album? }.length
    assert_equal 20, s.discography {|e| e.single? }.length

    assert_equal 16, s.discography {|e| e.single? and e.major? }.length

    # select でフィルタ
    assert_equal 4, s.discography.select {|e| e.indies? }.length
    assert_equal 24, s.discography.select {|e| e.major? }.length

    assert_equal 3, s.discography.select {|e| e.album? }.length
    assert_equal 20, s.discography.select {|e| e.single? }.length

    assert_equal 16, s.discography.select {|e| e.single? and e.major? }.length
  end

  def test_tracks
    s = ::Acme::Smileage.new
    assert_equal 65, s.tracks.length
    assert_equal 9, s.tracks.select {|e| e.cover? }.length
    assert_equal 8, s.tracks.select {|e| e.remix? }.length
  end

  def test_find_discography
    s = ::Acme::Smileage.new

    a = s.discography.find {|e| e.name =~ /夢見る/ }
    assert_equal a, s.find_discography("夢15")
    assert_equal a, s.find_discography("夢 15")
    assert_equal a, s.find_discography("夢１５")
    assert_equal a, s.find_discography("夢フィフ")

    a = s.discography.find {|e| e.name =~ /スマイルセンセーション/ }
    assert_equal a, s.find_discography("スマセン")
    assert_equal a, s.find_discography("スマイルセンセーション")
    assert_equal a, s.find_discography("スマイル センセーション")
  end

  def test_find_track
    s = ::Acme::Smileage.new

    a = s.tracks.find {|e| e.name =~ /夢見る/ }
    assert_equal a, s.find_track("夢15")
    assert_equal a, s.find_track("夢 15")
    assert_equal a, s.find_track("夢１５")
    assert_equal a, s.find_track("夢フィフ")

    a = s.tracks.find {|e| e.name =~ /ちょいと/ }
    assert_equal a, s.find_track("ちょいかわ")
    assert_equal a, s.find_track("チョイカワ")
    assert_equal a, s.find_track("裏番長")
    assert_equal a, s.find_track("ちょいかわ番長")
    assert_equal a, s.find_track("チョイカワ番長")
    assert_equal a, s.find_track("私、ちょいとかわいい裏番長")
    assert_equal a, s.find_track("私、ちょいとカワイイ裏番長")
    assert_equal a, s.find_track("私、チョイトカワイイ裏番長")
  end

  def test_oricon_total_sales
    s = ::Acme::Smileage.new

    assert_equal 399, s.oricon_total_sales {|e| e.single? and e.release_year == 2009 }
    assert_equal 81248, s.oricon_total_sales {|e| e.single? and e.release_year == 2010 }
    assert_equal 140449, s.oricon_total_sales {|e| e.single? and e.release_year == 2011 }
    assert_equal 89867, s.oricon_total_sales {|e| e.single? and e.release_year == 2012 }
    assert_equal 89365, s.oricon_total_sales {|e| e.single? and e.release_year == 2013 }

    assert_equal 428362, s.oricon_total_sales {|e| e.release_date < Date.new(2014, 1, 1) }
  end
end
