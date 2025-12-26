# 輸送イベント海域情報
class CopInfo
  # TPゲージの残量
  attr_accessor :numerator

  # TPゲージの最大数
  attr_accessor :denominator

  # 現在の周回数（1周目＝クリア周回数0の場合は1）
  attr_accessor :achievement_number

  # 次回達成ボーナス(IndividualAchievement)のリスト
  attr_accessor :individual_achievement

  # "全提督協力作戦 達成報酬獲得権利" の権利獲得済かどうか
  attr_accessor :area_achievement_claim

  # 限定フレームの所持数
  attr_accessor :limited_frame_num

  # 海域データ(AreaData)のリスト
  attr_accessor :area_data_list

  # 次回達成ボーナス
  class CopInfoIndividualAchievement
    # 表示順（0 〜）
    attr_accessor :data_id

    # ボーナスの種類
    # "RESULT_POINT": 戦果
    # "STRATEGY_POINT": 戦略ポイント
    # "ROOM_ITEM_ICON": 家具コイン
    # "EQUIP": 装備
    # "TRC_FRAME": 限定フレーム
    attr_accessor :kind

    # 数値（戦果の場合はポイント数、家具コインの場合はコイン枚数）
    attr_accessor :value
  end

  # 海域データ
  # 情報量が多いが、Admiral Statsではその大半が不要なため、
  # Admiral Statsで最低限必要なデータだけパースする
  class CopInfoAreaData
    # 海域番号
    # 期間限定作戦「兵站輸送作戦」では、共通して 3000
    attr_accessor :area_id

    # サブ海域番号
    # 期間限定作戦「兵站輸送作戦」では、1 〜 3
    attr_accessor :area_sub_id
  end
end
