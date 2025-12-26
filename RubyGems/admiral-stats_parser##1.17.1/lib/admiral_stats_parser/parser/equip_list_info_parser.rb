require 'json'
require 'admiral_stats_parser/model/equip_list_info'

class EquipListInfoParser
  MANDATORY_KEYS = {
    type: Integer,
    equipment_id: Integer,
    name: String,
    num: Integer,
    img: String,
  }

  # 装備一覧のみをパースした結果を返します。
  def self.parse(json, api_version)
    case api_version
      when 1
        # 最初のバージョンには、装備情報の配列のみが入っている
        equip_list = JSON.parse(json)
        unless equip_list.is_a?(Array)
          raise 'json is not an Array'
        end

        parse_equip_list(equip_list)
      when 2
        # 第2のバージョンには、連想配列が入っている
        info = JSON.parse(json)
        unless info.is_a?(Hash)
          raise 'json is not a Hash'
        end

        parse_equip_list(info['equipList'])
    end
  end

  # 最大装備保有数のみをパースした結果を返します。
  def self.parse_max_slot_num(json, api_version)
    case api_version
      when 1
        # 最大装備保有数の拡張に対応する前なので、常に 500
        500
      when 2
        info = JSON.parse(json)
        unless info.is_a?(Hash)
          raise 'json is not a Hash'
        end
        info['maxSlotNum']
    end
  end

  private

  # version 1 の配列、および version 2 の equipList キーの値を受け取り、その結果を EquipListInfo[] に変換して返します。
  def self.parse_equip_list(equip_list)
    results = []
    equip_list.each do |items|
      result = EquipListInfo.new

      MANDATORY_KEYS.each do |key, key_class|
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

      results << result
    end

    results
  end
end
