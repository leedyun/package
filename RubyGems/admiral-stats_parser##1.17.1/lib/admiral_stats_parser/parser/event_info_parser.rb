require 'json'
require 'admiral_stats_parser/model/event_info'

class EventInfoParser
  MANDATORY_KEYS = {
      1 => {
          area_id: Integer,
          area_sub_id: Integer,
          level: String,
          area_kind: String,
          limit_sec: Integer,
          require_gp: Integer,
          sortie_limit: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          reward_list: :reward_list,
          stage_drop_item_info: Array,
          area_clear_state: String,
          military_gauge_status: String,
          ene_military_gauge_val: Integer,
          military_gauge_left: Integer,
          boss_status: String,
          loop_count: Integer,
      },
      2 => {
          area_id: Integer,
          area_sub_id: Integer,
          level: String,
          area_kind: String,
          limit_sec: Integer,
          require_gp: Integer,
          sortie_limit: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          reward_list: :reward_list,
          stage_drop_item_info: Array,
          area_clear_state: String,
          military_gauge_status: String,
          ene_military_gauge_val: Integer,
          military_gauge_left: Integer,
          ene_military_gauge2d: String,
          loop_count: Integer,
          period: Integer,
      },
      3 => {
          area_id: Integer,
          area_sub_id: Integer,
          level: String,
          area_kind: String,
          limit_sec: Integer,
          require_gp: Integer,
          sortie_limit: :boolean,
          stage_image_name: String,
          stage_mission_name: String,
          stage_mission_info: String,
          reward_list: :reward_list,
          stage_drop_item_info: Array,
          area_clear_state: String,
          military_gauge_status: String,
          ene_military_gauge_val: Integer,
          military_gauge_left: Integer,
          ene_military_gauge2d: String,
          loop_count: Integer,
          period: Integer,
      },
  }

  OPTIONAL_KEYS = {
      1 => {},
      2 => {},
      3 => {
          sortie_limit_img: String,
          disp_add_level: String,
          ng_unit_img: String,
      }
  }

  REWARD_LIST_MANDATORY_KEYS = {
      data_id: Integer,
      kind: String,
      value: Integer,
  }

  REWARD_LIST_OPTIONAL_KEYS = {
      reward_type: String,
  }

  def self.parse(json, api_version)
    items_array = JSON.parse(json)

    unless items_array.is_a?(Array)
      raise 'json is not an Array'
    end

    results = []
    items_array.each do |items|
      result = EventInfo.new

      MANDATORY_KEYS[api_version].each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless items.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 結果のクラスが合わなければエラー
        # 海域撃破ボーナスを格納するために、特別な処理を追加
        if key_class == :reward_list
          result.instance_variable_set(
              "@#{key.to_s}", EventInfoParser.parse_reward_list(items[camel_case_key]))
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

      results << result
    end

    results
  end

  def self.parse_reward_list(rewards)
    results = []

    rewards.each do |reward|
      result = EventInfo::EventInfoReward.new

      REWARD_LIST_MANDATORY_KEYS.each do |key, key_class|
        # 必須のキーが含まれなければエラー
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        unless reward.include?(camel_case_key)
          raise "Mandatory key #{key} does not exist"
        end

        # 結果のクラスが合わなければエラー
        unless reward[camel_case_key].is_a?(key_class)
          raise "Mandatory key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", reward[camel_case_key])
      end

      REWARD_LIST_OPTIONAL_KEYS.each do |key, key_class|
        # キーが含まれなければ、処理をスキップ
        camel_case_key = key.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
        next unless reward.include?(camel_case_key)

        # 結果のクラスが合わなければエラー
        unless reward[camel_case_key].is_a?(key_class)
          raise "Optional key #{key} is not class #{key_class}"
        end

        result.instance_variable_set("@#{key.to_s}", reward[camel_case_key])
      end

      results << result
    end

    results
  end

  # 与えられたリストから、現在の周回数を返します。
  # その作戦が未開放の場合は nil を返します。
  def self.current_loop_counts(event_info_list, level, period = nil)
    # 指定されたレベルの情報のみ取り出し
    list = event_info_list.select{|info| info.level == level and info.period == period }

    # その難易度および作戦のデータがない場合は nil
    return nil if list.empty?

    # 現在の周回数
    list.map{|i| i.loop_count }.max
  end

  # 与えられたリストから、クリア済みの周回数を返します。
  # その作戦が未開放の場合は nil を返します。
  def self.cleared_loop_counts(event_info_list, level, period = nil)
    # 指定されたレベルの情報のみ取り出し
    list = event_info_list.select{|info| info.level == level and info.period == period }

    # その難易度および作戦のデータがない場合は nil
    return nil if list.empty?

    # その周回をクリア済みかどうか
    cleared = EventInfoParser.all_cleared?(event_info_list, level, period)

    # 現在の周回数
    loop_count = list.map{|i| i.loop_count }.max

    cleared ? loop_count : loop_count - 1
  end

  # 与えられたリストから、現在の周回でクリア済みのステージ No. を返します。
  # 丙 E-1 クリア済みの場合も、乙 E-1 クリア済みの場合も 1 を返します。
  # E-1 未クリアの場合は 0 を返します。
  # その難易度または作戦が未開放の場合は 0 を返します。
  def self.cleared_stage_no(event_info_list, level, period = nil)
    # その難易度が未開放の場合は、0 を返す
    return 0 unless EventInfoParser.opened?(event_info_list, level, period)

    # 指定されたレベルの情報を、サブ海域番号の小さい順に取り出し
    list = event_info_list.select{|info| info.level == level and info.period == period }.sort_by {|info| info.area_sub_id }

    list.each_with_index do |info, prev_stage_no|
      return prev_stage_no if info.area_clear_state == 'NOTCLEAR'
    end

    # NOTCLEAR のエリアがなければ、最終海域の番号を返す
    list.size
  end

  # 与えられたリストから、攻略中のステージの海域ゲージの現在値を返します。
  # 全ステージクリア後、および掃討戦の場合は 0 を返します。
  # その難易度または作戦が未開放の場合は 0 を返します。
  def self.current_military_gauge_left(event_info_list, level, period = nil)
    # 全ステージクリア後は 0 を返す
    return 0 if EventInfoParser.all_cleared?(event_info_list, level, period)

    # 指定されたレベルの情報を、サブ海域番号の小さい順に取り出し
    list = event_info_list.select{|info| info.level == level and info.period == period }.sort_by {|info| info.area_sub_id }

    list.each do |info|
      if info.area_clear_state == 'NOTCLEAR' or info.area_clear_state == 'NOOPEN'
        return info.military_gauge_left
      end
    end

    # NOTCLEAR のエリアがなければ 0 を返す
    0
  end

  # 与えられた難易度が解放済みの場合に true を返します。
  def self.opened?(event_info_list, level, period = nil)
    # 指定されたレベルの情報を、サブ海域番号の小さい順に取り出し
    list = event_info_list.select{|info| info.level == level and info.period == period }.sort_by {|info| info.area_sub_id }

    # その難易度のデータがなければ、未開放と見なす（通常は発生しない）
    return false if list.size == 0

    # 最初の海域の状態が NOOPEN の場合は未開放
    return false if list.first.area_clear_state == 'NOOPEN'

    true
  end

  # 与えられた難易度の全海域をクリア済みの場合に true を返します。
  # その難易度が解放済みで、かつ 'NOTCLEAR' の海域が存在しない場合はクリア済みとみなします。
  def self.all_cleared?(event_info_list, level, period = nil)
    return false unless EventInfoParser.opened?(event_info_list, level, period)

    # 指定されたレベルの情報を、サブ海域番号の小さい順に取り出し
    list = event_info_list.select{|info| info.level == level and info.period == period }.sort_by {|info| info.area_sub_id }
    list.select{|i| i.area_clear_state == 'NOTCLEAR' }.size == 0
  end
end
