require 'json'
require 'admiral_stats_parser/model/area_capture_info'

class AreaCaptureInfoParser
  MANDATORY_KEYS = {
      1 => {
          area_id: Integer,
          area_sub_id: Integer,
          limit_sec: Integer,
          pursuit_map: :boolean,
          pursuit_map_open: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          stage_clear_item_info: String,
          stage_drop_item_info: Array,
          area_clear_state: String,
      },
      2 => {
          area_id: Integer,
          area_sub_id: Integer,
          limit_sec: Integer,
          require_gp: Integer,
          pursuit_map: :boolean,
          pursuit_map_open: :boolean,
          sortie_limit: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          stage_clear_item_info: String,
          stage_drop_item_info: Array,
          area_clear_state: String,
      },
      3 => {
          area_id: Integer,
          area_sub_id: Integer,
          limit_sec: Integer,
          require_gp: Integer,
          pursuit_map: :boolean,
          pursuit_map_open: :boolean,
          sortie_limit: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          stage_clear_item_info: String,
          stage_drop_item_info: Array,
          area_clear_state: String,
      },
      4 => {
          area_id: Integer,
          area_sub_id: Integer,
          limit_sec: Integer,
          require_gp: Integer,
          pursuit_map: :boolean,
          pursuit_map_open: :boolean,
          sortie_limit: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          stage_clear_item_info: String,
          stage_drop_item_info: Array,
          area_clear_state: String,
      },
  }

  OPTIONAL_KEYS = {
      1 => {},
      2 => {},
      3 => {
          boss_info: :boss_info,
      },
      4 => {
          boss_info: :boss_info,
          route: String,
      },
  }

  BOSS_INFO_MANDATORY_KEYS = {
      military_gauge_status: String,
      ene_military_gauge_val: Integer,
      military_gauge_left: Integer,
      boss_status: String,
  }

  def self.parse(json, api_version)
    items_array = JSON.parse(json)

    unless items_array.is_a?(Array)
      raise 'json is not an Array'
    end

    results = []
    items_array.each do |items|
      result = AreaCaptureInfo.new

      MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless items.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 結果のクラスが合わなければエラー
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
        # 海域ボスの情報を格納するために、特別な処理を追加
        if key_class == :boss_info
          result.instance_variable_set(
              "@#{key.to_s}", AreaCaptureInfoParser.parse_boss_info(items[camel_case_key]))
          next
        end

        unless items[camel_case_key].is_a?(key_class)
          raise "Optional key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", items[camel_case_key])
      end

      results << result
    end

    results
  end

  def self.parse_boss_info(boss_info)
    result = AreaCaptureInfo::BossInfo.new

    BOSS_INFO_MANDATORY_KEYS.each do |key, key_class|
      # 必須のキーが含まれなければエラー
      camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
      unless boss_info.include?(camel_case_key)
        raise "Mandatory key #{key} does not exist"
      end

      # 結果のクラスが合わなければエラー
      unless boss_info[camel_case_key].is_a?(key_class)
        raise "Mandatory key #{key} is not class #{key_class}"
      end

      result.instance_variable_set("@#{key.to_s}", boss_info[camel_case_key])
    end

    result
  end
end
