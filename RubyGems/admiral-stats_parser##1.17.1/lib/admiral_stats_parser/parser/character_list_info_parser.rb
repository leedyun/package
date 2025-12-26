require 'json'
require 'admiral_stats_parser/model/character_list_info'

class CharacterListInfoParser
  MANDATORY_KEYS = {
      1 => {
          book_no: Integer,
          lv: Integer,
          ship_type: String,
          ship_sort_no: Integer,
          remodel_lv: Integer,
          ship_name: String,
          status_img: String,
      },
      2 => {
          book_no: Integer,
          lv: Integer,
          ship_type: String,
          ship_sort_no: Integer,
          remodel_lv: Integer,
          ship_name: String,
          status_img: String,
          star_num: Integer,
      },
      3 => {
          book_no: Integer,
          lv: Integer,
          ship_type: String,
          ship_sort_no: Integer,
          remodel_lv: Integer,
          ship_name: String,
          status_img: String,
          star_num: Integer,
          ship_class: String,
          ship_class_index: Integer,
          tc_img: String,
          exp_percent: Integer,
          max_hp: Integer,
          real_hp: Integer,
          damage_status: String,
          slot_num: Integer,
          slot_equip_name: Array,
          slot_amount: Array,
          slot_disp: Array,
          slot_img: Array,
      },
      4 => {
          book_no: Integer,
          lv: Integer,
          ship_type: String,
          ship_sort_no: Integer,
          remodel_lv: Integer,
          ship_name: String,
          status_img: String,
          star_num: Integer,
          ship_class: String,
          ship_class_index: Integer,
          tc_img: String,
          exp_percent: Integer,
          max_hp: Integer,
          real_hp: Integer,
          damage_status: String,
          slot_num: Integer,
          slot_equip_name: Array,
          slot_amount: Array,
          slot_disp: Array,
          slot_img: Array,
          blueprint_total_num: Integer,
      },
      5 => {
          book_no: Integer,
          lv: Integer,
          ship_type: String,
          ship_sort_no: Integer,
          remodel_lv: Integer,
          ship_name: String,
          status_img: String,
          star_num: Integer,
          ship_class: String,
          ship_class_index: Integer,
          tc_img: String,
          exp_percent: Integer,
          max_hp: Integer,
          real_hp: Integer,
          damage_status: String,
          slot_num: Integer,
          slot_equip_name: Array,
          slot_amount: Array,
          slot_disp: Array,
          slot_img: Array,
          blueprint_total_num: Integer,
          married: :boolean,
      },
      6 => {
          book_no: Integer,
          lv: Integer,
          ship_type: String,
          ship_sort_no: Integer,
          remodel_lv: Integer,
          ship_name: String,
          status_img: String,
          star_num: Integer,
          ship_class: String,
          tc_img: String,
          exp_percent: Integer,
          max_hp: Integer,
          real_hp: Integer,
          damage_status: String,
          slot_num: Integer,
          slot_equip_name: Array,
          slot_amount: Array,
          slot_disp: Array,
          slot_img: Array,
          blueprint_total_num: Integer,
          married: :boolean,
      },
  }

  OPTIONAL_KEYS = {
      1 => {},
      2 => {},
      3 => {},
      4 => {},
      5 => {},
      6 => {
          ship_class_index: Integer,
      },
  }

  def self.parse(json, api_version)
    items_array = JSON.parse(json)

    unless items_array.is_a?(Array)
      raise 'json is not an Array'
    end

    results = []
    items_array.each do |items|
      result = CharacterListInfo.new

      MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless items.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # ruby には Boolean クラスがないので、そこだけ特別な処理を用意する
        if key_class == :boolean
          unless [true, false].include?(items[camel_case_key])
            raise "Mandatory key #{key} is not boolean"
          end
        else
          unless items[camel_case_key].is_a?(key_class)
            raise "Mandatory key #{key} is not class #{key_class}"
          end
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
end
