# coding: utf-8

require 'test/unit'
require 'at_least_one_existence_validator'
require 'active_record'
require 'test_helper'

class ValidatorTest < Test::Unit::TestCase
  def test_helper_method_existence
    assert_respond_to ActiveRecord::Base, :validates_at_least_one_existence_of, "ActiveRecord::Base doesn't have helper method"
  end

  def test_omitted_authors
    validate book_with_omitted_authors, "Validator is passed if collection is nil"
  end

  def test_rphaned_book
    validate orphaned_book, "Validator is passed if collection is empty"
  end

  def test_book_with_an_author
    validate book_with_an_author      , "Validator isn't passed if collection has only one item", 0
    validate book_with_an_author(true), "Validator passed if the only item of its collection is marked for destruction"
  end

  def test_book_with_some_authors
    validate book_with_some_authors, "Validator isn't passed if all items of its collection are not marked for destruction", 0
    validate book_with_some_authors([true, false]*2), "Validator isn't passed if some items of its collection are not marked for destruction", 0
    validate book_with_some_authors([true]*5), "Validator is passed if all the items of its collection are marked for destruction"
  end

  def test_error_message
    messages = {
      en: 'must have at least one item.',
      ru: 'должен иметь, по крайней мере, один элемент.'
    }

    missed_locales   = messages.keys          - I18n.available_locales
    assert missed_locales.empty?, "Missed locales: #{missed_locales.to_s}"

    surplus_locales  = I18n.available_locales - messages.keys
    assert surplus_locales.empty?, "Surplus locales: #{surplus_locales.to_s}"

    I18n.available_locales.each do |locale|
      I18n.locale = locale
      expected    = messages[locale]
      actual      = I18n.t 'errors.messages.at_least_one'
      assert_equal expected, actual, "Expected message is '#{expected}', actual message is '#{actual}', locale is '#{locale.to_s}'"
    end
  end

  include TestHelper

  private

  def validate tested_book, message, errors_size = 1
    assert_nothing_raised { ActiveModel::Validations::AtLeastOneExistenceValidator.new({ attributes: [:authors] }).validate tested_book }
    assert tested_book.errors.size == errors_size, message
  end
end
