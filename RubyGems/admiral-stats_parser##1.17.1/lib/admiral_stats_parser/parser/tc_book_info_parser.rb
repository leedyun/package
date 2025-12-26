require 'json'
require 'admiral_stats_parser/model/tc_book_info'

class TcBookInfoParser
  MANDATORY_KEYS = {
    1 => {
      book_no: Integer,
      ship_class: String,
      ship_class_index: Integer,
      ship_type: String,
      ship_name: String,
      card_index_img: String,
      card_img_list: Array,
      variation_num: Integer,
      acquire_num: Integer,
#      lv: Integer,
#      status_img: Array,
    },
    2 => {
      book_no: Integer,
      ship_class: String,
      ship_class_index: Integer,
      ship_type: String,
      ship_name: String,
      card_index_img: String,
      card_img_list: Array,
      variation_num: Integer,
      acquire_num: Integer,
      lv: Integer,
      status_img: Array,
    },
    3 => {
        book_no: Integer,
        ship_class: String,
        ship_class_index: Integer,
        ship_type: String,
        ship_name: String,
        card_index_img: String,
        card_img_list: Array,
        variation_num: Integer,
        acquire_num: Integer,
        lv: Integer,
        status_img: Array,
    },
    4 => {
        book_no: Integer,
        ship_class: String,
        ship_type: String,
        ship_name: String,
        card_index_img: String,
        card_img_list: Array,
        variation_num: Integer,
        acquire_num: Integer,
        lv: Integer,
        status_img: Array,
    },
    5 => {
        book_no: Integer,
        ship_class: String,
        ship_type: String,
        ship_name: String,
        card_index_img: String,
        card_list: :card_list,
        variation_num: Integer,
        acquire_num: Integer,
        lv: Integer,
    },
  }

  OPTIONAL_KEYS = {
      1 => {},
      2 => {},
      3 => {
          is_married: Array,
          married_img: Array,
      },
      4 => {
          ship_class_index: Integer,
          is_married: Array,
          married_img: Array,
      },
      5 => {
          ship_class_index: Integer,
          is_married: Array,
          married_img: Array,
      },
  }

  CARD_LIST_MANDATORY_KEYS = {
      5 => {
          priority: Integer,
          card_img_list: Array,
          variation_num_in_page: Integer,
          acquire_num_in_page: Integer,
      },
  }

  CARD_LIST_OPTIONAL_KEYS = {
      5 => {
          status_img: Array,
      },
  }

  def self.parse(json, api_version)
    items_array = JSON.parse(json)

    unless items_array.is_a?(Array)
      raise 'json is not an Array'
    end

    results = []
    items_array.each do |items|
      result = TcBookInfo.new

      MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless items.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # # 有効期限の情報を格納するために、特別な処理を追加
        if key_class == :card_list
          result.instance_variable_set(
              "@#{key.to_s}", TcBookInfoParser.parse_card_list(result, items[camel_case_key], api_version))
          next
        end

        # 結果のクラスが合わなければエラー
        unless items[camel_case_key].is_a?(key_class)
          raise "Mandatory key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", items[camel_case_key])
      end

      OPTIONAL_KEYS[api_version].each do |key, key_class|
        # キーが含まれなければ、処理をスキップ
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        next unless items.include?(camel_case_key)

        # 結果のクラスが合わなければエラー
        unless items[camel_case_key].is_a?(key_class)
          raise "Optional key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", items[camel_case_key])
      end

      results << result
    end

    results
  end

  def self.parse_card_list(tc_book_info, card_list, api_version)
    results = []

    card_list.each do |c|
      result = TcBookInfoParser::CardList.new

      CARD_LIST_MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless c.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist: #{tc_book_info.book_no}"
        end

        # 結果のクラスが合わなければエラー
        unless c[camel_case_key].is_a?(key_class)
          raise "Optional key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", c[camel_case_key])
      end

      CARD_LIST_OPTIONAL_KEYS[api_version].each do |key, key_class|
        # キーが含まれなければ、処理をスキップ
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        next unless c.include?(camel_case_key)

        # 結果のクラスが合わなければエラー
        unless c[camel_case_key].is_a?(key_class)
          raise "Optional key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", c[camel_case_key])
      end

      results << result
    end

    # admiral_stats_parser は限定カード未対応のため、priority == 0 の要素のみを処理する
    results = results.select{|r| r.priority == 0 }

    case results.size
      when 0
        # 未入手、または priority == 0 のデータが存在しない場合
        tc_book_info.card_img_list = []
        tc_book_info.status_img = []
      else
        tc_book_info.card_img_list = results[0].card_img_list
        tc_book_info.status_img = results[0].status_img
    end
  end

  class CardList
    # 不明
    # いまは配列中の要素が1個しかないが、これが2個以上になったときに意味が出てくる？
    attr_accessor :priority

    # 取得済み画像のファイル名
    # Array
    # 未取得の場合は、空の Array
    attr_accessor :card_img_list

    # 艦娘のステータス画像（横長の画像）のファイル名 (From API version 2)
    # Array
    # 未取得の場合は、空の Array
    attr_accessor :status_img

    # 不明
    attr_accessor :variation_num_in_page

    # 不明
    attr_accessor :acquire_num_in_page
  end
end
