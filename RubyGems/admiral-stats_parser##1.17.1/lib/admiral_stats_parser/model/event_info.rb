# 限定海域情報
class EventInfo
  # 海域番号
  # 期間限定海域「敵艦隊前線泊地殴り込み」では、共通して 1000
  attr_accessor :area_id

  # サブ海域番号
  # 期間限定海域「敵艦隊前線泊地殴り込み」では、1 〜 10
  attr_accessor :area_sub_id

  # 難易度
  # "HEI": 丙
  # "OTU": 乙
  # "KOU": 甲
  attr_accessor :level

  # 海域の種類
  # ボス戦は "BOSS"
  # 掃討戦は "SWEEP"
  # 前段作戦の最終海域は "PERIOD_LAST"
  # EO の最終戦は "BOSS_RAID_FINAL" (From API version 13)
  # それ以外は "NORMAL" （EO も "NORMAL"）
  attr_accessor :area_kind

  # 作戦時間（秒）
  # 未表示の場合は 0
  attr_accessor :limit_sec

  # 必要GP
  # 未表示の場合は 0
  attr_accessor :require_gp

  # 出撃条件の有無（true ならある）
  attr_accessor :sortie_limit

  # 出撃条件の画像 (From API version 13)
  attr_accessor :sortie_limit_img

  # 海域画像のファイル名
  attr_accessor :stage_image_name

  # 作戦名
  # 未表示の場合は "？"
  attr_accessor :stage_mission_name

  # 作戦内容
  # 未表示の場合は "？"
  attr_accessor :stage_mission_info

  # 海域撃破ボーナス(EventInfoReward)のリスト
  attr_accessor :reward_list

  # 主な出現アイテム
  # アイテムを表す文字列の配列（要素数は4固定）
  attr_accessor :stage_drop_item_info

  # クリア状態を表す文字列
  # CLEAR: クリア済み
  # NOTCLEAR: 出撃可能だが未クリア
  # NOOPEN: 出撃不可（掃討戦クリア後は CLEAR にならず NOOPEN に戻る）
  attr_accessor :area_clear_state

  # 海域ゲージの状態
  # "NORMAL": 攻略中
  # "BREAK": 攻略後
  attr_accessor :military_gauge_status

  # 海域ゲージの最大値
  # E-1 攻略開始前は 1000、攻略後も 1000
  attr_accessor :ene_military_gauge_val

  # 海域ゲージの現在値
  # E-1 攻略開始前は 1000、攻略後は 0
  attr_accessor :military_gauge_left

  # ボスのランク (API version 7 で廃止)
  # 泊地棲鬼は "ONI"
  # ゲージ半減して泊地棲姫になると "HIME"
  # それ以外は "NONE"
  attr_accessor :boss_status

  # 海域ゲージに表示されるボスアイコンの種類？ (From API version 7)
  attr_accessor :ene_military_gauge2d

  # 周回数
  # E-1 攻略開始前は 1、攻略後も 1
  attr_accessor :loop_count

  # 前段作戦か後段作戦か (From API version 7)
  # 0: 前段作戦
  # 1: 後段作戦
  # 2: EO (From API version 13)
  attr_accessor :period

  # この EO のデータの表示箇所？ (From API version 13)
  # 乙・丙の EO の場合のみ "HEI"
  # それ以外の場合はキー自体がない
  attr_accessor :disp_add_level

  # 出撃不可の艦種を表すアイコン (From API version 13)
  attr_accessor :ng_unit_img

  # 海域撃破ボーナス
  class EventInfoReward
    # 初回攻略時か2回目以降かを表すフラグ
    # "FIRST": 初回
    # "SECOND": 2回目以降
    # 未公開状態の場合は、項目なし
    attr_accessor :reward_type

    # 表示順（0 〜）
    attr_accessor :data_id

    # ボーナスの種類
    # "NONE": 未公開状態
    # "RESULT_POINT": 戦果
    # "STRATEGY_POINT": 戦略ポイント
    # "ROOM_ITEM_ICON": 家具コイン
    # "ROOM_ITEM_MEISTER": 特注家具職人
    # "EQUIP": 装備
    # "TLOP_KOU_MEDAL": 甲種勲章 (From API version 13)
    attr_accessor :kind

    # 数値（戦果の場合はポイント数、家具コインの場合はコイン枚数）
    attr_accessor :value
  end
end
