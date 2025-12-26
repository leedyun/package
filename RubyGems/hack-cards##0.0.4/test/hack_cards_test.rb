require "test_helper"

class HackCardsTest < Test::Unit::TestCase
  def test_new
    card = HackCards::Card.new(text: "test", url: "www.hackstarter.com")
    assert_equal "test", card.text
    assert_equal "www.hackstarter.com", card.url
  end

  def test_default_value
    card = HackCards::Card.new
    assert_equal nil, card.text
    assert_equal nil, card.url
  end

  def test_text_only_type
    card = HackCards::Card.new(text: "Hello World")
    assert_equal :text, card.type
  end

  def test_url_only_type
    card = HackCards::Card.new(url: "www.hackstarter.com")
    assert_equal :url, card.type
  end

  def test_multiple_types
    card = HackCards::Card.new(text: "I am some words", url: "www.lmgtfy.com")
    assert_equal :text_url, card.type
  end

  def test_single_components
    card_one = HackCards::Card.new(text: "example")
    assert_equal [:text], card_one.components

    card_two = HackCards::Card.new(url: "www.hackstarter.com")
    assert_equal [:url], card_two.components
  end

  def test_multiple_components
    card = HackCards::Card.new(text: "hey some text", url: "www.imastring.com")
    assert_equal [:text, :url], card.components
  end

  def test_display_only_text
    card = HackCards::Card.new(text: "paragraph")
    assert_equal "<p>paragraph</p>", card.display
  end
end
