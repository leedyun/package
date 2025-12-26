require 'json'
require 'admiral_stats_parser/model/cop_info'

class CopInfoParser
  MANDATORY_KEYS = {
      1 => {
          numerator: Integer,
          denominator: Integer,
          achievement_number: Integer,
          individual_achievement: :individual_achievement,
          area_achievement_claim: :boolean,
          limited_frame_num: Integer,
          area_data_list: :area_data_list
      },
  }

  OPTIONAL_KEYS = {
      1 => {},
  }

  INDIVIDUAL_ACHIEVEMENT_MANDATORY_KEYS = {
      data_id: Integer,
      kind: String,
      value: Integer,
  }

  AREA_DATA_LIST_MANDATORY_KEYS = {
      area_id: Integer,
      area_sub_id: Integer,
  }

  def self.parse(json, api_version)
    items = JSON.parse(json)

    # イベント期間外はnilを返す
    return nil if items.empty?

    result = CopInfo.new

    MANDATORY_KEYS[api_version].each do |key, key_class|
      # 必須のキーが含まれなければエラー
      camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
      unless items.include?(camel_case_key)
        raise "Mandatory key #{key} does not exist"
      end

      # 結果のクラスが合わなければエラー
      # 海域撃破ボーナスを格納するために、特別な処理を追加
      if key_class == :individual_achievement
        result.instance_variable_set(
            "@#{key.to_s}", CopInfoParser.parse_individual_achievement(items[camel_case_key]))
        next
      elsif key_class == :area_data_list
        result.instance_variable_set(
            "@#{key.to_s}", CopInfoParser.parse_area_data_list(items[camel_case_key]))
        next
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

    result
  end

  def self.parse_individual_achievement(achievements)
    results = []

    achievements.each do |achievement|
      result = CopInfo::CopInfoIndividualAchievement.new

      INDIVIDUAL_ACHIEVEMENT_MANDATORY_KEYS.each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless achievement.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 結果のクラスが合わなければエラー
        unless achievement[camel_case_key].is_a?(key_class)
          raise "Mandatory key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", achievement[camel_case_key])
      end

      results << result
    end

    results
  end

  def self.parse_area_data_list(area_data_list)
    results = []

    area_data_list.each do |area_data|
      result = CopInfo::CopInfoAreaData.new

      AREA_DATA_LIST_MANDATORY_KEYS.each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless area_data.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 結果のクラスが合わなければエラー
        unless area_data[camel_case_key].is_a?(key_class)
          raise "Mandatory key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", area_data[camel_case_key])
      end

      results << result
    end

    results
  end
end
