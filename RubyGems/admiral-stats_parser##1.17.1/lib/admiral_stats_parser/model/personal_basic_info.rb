# 基本情報
class PersonalBasicInfo
  # 提督名
  attr_accessor :admiral_name

  # 燃料
  attr_accessor :fuel

  # 弾薬
  attr_accessor :ammo

  # 鋼材
  attr_accessor :steel

  # ボーキサイト
  attr_accessor :bauxite

  # 修復バケツ
  attr_accessor :bucket

  # 艦隊司令部Level
  attr_accessor :level

  # 家具コイン
  attr_accessor :room_item_coin

  # 戦果 (From API version 2)
  # 戦果は数値だが、なぜか STRING 型で返される。どういう場合に文字列が返されるのか？
  attr_accessor :result_point

  # 暫定順位 (From API version 2)
  # 数値または「圏外」
  attr_accessor :rank

  # 階級を表す数値 (From API version 2)
  attr_accessor :title_id

  # 最大備蓄可能各資源量 (From API version 2)
  attr_accessor :material_max

  # 戦略ポイント (From API version 2)
  attr_accessor :strategy_point

  # 甲種勲章の数 (From API version 7)
  attr_accessor :kou_medal
end
