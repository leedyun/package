# -*- encoding: utf-8 -*-

require "date"

require "minitest_helper"

class Acme::TestMember < Minitest::Test
  def test_member_all
    s = ::Acme::Smileage.new
    rp = s.members.select {|e| e.name =~ /Rina/ }.first

    assert_equal "勝田", rp.family_name_ja
    assert_equal "里奈", rp.first_name_ja
    assert_equal "Katsuta", rp.family_name_en
    assert_equal "Rina", rp.first_name_en
    assert_equal Date.new(1998, 4, 6), rp.birthday
    assert_equal "A", rp.blood_type
    assert_equal "東京", rp.hometown
    assert_equal "ﾘﾅp´ v｀)", rp.emoticon
    assert_equal ["りなぷ～"], rp.nicknames
    assert_equal ["りなぷ～"], rp.nick
    assert_equal "Yellow", rp.member_color
    assert_equal "Yellow", rp.color
    assert_equal "http://ameblo.jp/smileage-submember/", rp.blog_link
    assert_equal ["@smileage_newmem", "@smileage_715"], rp.twitter_accounts
    assert_equal 2, rp.generation
    assert_equal Date.new(2011, 8, 14), rp.join_date
    assert_equal nil, rp.graduate_date

    assert_equal 15, rp.age(Date.new(2014, 4, 5))
    assert_equal 16, rp.age(Date.new(2014, 4, 6))

    assert_equal false, rp.active?(Date.new(2011, 8, 13))
    assert_equal true, rp.active?(Date.new(2011, 8, 14))
    assert_equal true, rp.active?(Date.new(2014, 4, 6))

    assert_equal false, rp.graduated?(Date.new(2011, 8, 13))
    assert_equal false, rp.graduated?(Date.new(2011, 8, 14))
    assert_equal false, rp.graduated?(Date.new(2014, 4, 6))

    assert_equal "Rina Katsuta", rp.name
    assert_equal "Rina Katsuta", rp.name_en
    assert_equal "勝田里奈", rp.name_ja
  end
end
