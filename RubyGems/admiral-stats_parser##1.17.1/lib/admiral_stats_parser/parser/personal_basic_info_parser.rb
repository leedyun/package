require 'json'
require 'admiral_stats_parser/model/personal_basic_info'

class PersonalBasicInfoParser
  MANDATORY_KEYS = {
    1 => {
      fuel: Integer,
      ammo: Integer,
      steel: Integer,
      bauxite: Integer,
      bucket: Integer,
      level: Integer,
      room_item_coin: Integer,
    },
    2 => {
      fuel: Integer,
      ammo: Integer,
      steel: Integer,
      bauxite: Integer,
      bucket: Integer,
      level: Integer,
      room_item_coin: Integer,
      result_point: String,
      rank: String,
      title_id: Integer,
      material_max: Integer,
      strategy_point: Integer,
    },
    3 => {
        fuel: Integer,
        ammo: Integer,
        steel: Integer,
        bauxite: Integer,
        bucket: Integer,
        level: Integer,
        room_item_coin: Integer,
        result_point: String,
        rank: String,
        title_id: Integer,
        material_max: Integer,
        strategy_point: Integer,
        kou_medal: Integer,
    },
  }

  OPTIONAL_KEYS = {
    1 => {
      # 元のデータには必ず提督名が含まれるが、データ解析の上では不要のため、オプションとする
      admiral_name: String,
    },
    2 => {
      admiral_name: String,
    },
    3 => {
        admiral_name: String,
    }
  }

  def self.parse(json, api_version)
    items = JSON.parse(json)

    result = PersonalBasicInfo.new

    MANDATORY_KEYS[api_version].each do |key, key_class|
      # 必須のキーが含まれなければエラー
      camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
      unless items.include?(camel_case_key)
        raise "Mandatory key #{key} does not exist"
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

    result
  end
end
