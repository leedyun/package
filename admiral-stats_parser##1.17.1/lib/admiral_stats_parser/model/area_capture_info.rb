# 海域情報
class AreaCaptureInfo
  # 海域番号
  attr_accessor :area_id

  # サブ海域番号
  attr_accessor :area_sub_id

  # 作戦時間（秒）
  # 未表示の場合は 0
  attr_accessor :limit_sec

  # 必要GP (From API version 2)
  # 未表示の場合は 0
  attr_accessor :require_gp

  # 追撃戦かどうか（true なら追撃戦）
  attr_accessor :pursuit_map

  # 追撃戦が出現しているかどうか（true なら出現している）
  # 追撃戦の場合は常に false
  attr_accessor :pursuit_map_open

  # 出撃条件の有無（true ならある） (From API version 2)
  attr_accessor :sortie_limit

  # 海域画像のファイル名
  attr_accessor :stage_image_name

  # 作戦名
  attr_accessor :stage_mission_name

  # 作戦内容
  attr_accessor :stage_mission_info

  # 海域クリアボーナス
  # アイテムを表す、以下の文字列のいずれか
  # MEISTER: 特注家具職人
  # BUCKET: 修復バケツ
  # SMALLREC: 伊良湖
  # SMALLBOX: 家具コイン(小)
  # MEDIUMBOX: 家具コイン(中)
  # NONE: ボーナスなし
  # UNKNOWN: 海域が未表示の場合
  attr_accessor :stage_clear_item_info

  # 主な出現アイテム
  # アイテムを表す文字列の配列（要素数は4固定）
  attr_accessor :stage_drop_item_info

  # クリア状態を表す文字列
  # CLEAR: クリア済み
  # NOTCLEAR: 出撃可能だが未クリア
  # NOOPEN: 出撃不可
  attr_accessor :area_clear_state

  # 海域ボスの情報（ボスが存在する場合のみ） (From API version 7?)
  attr_accessor :boss_info

  # ルートの識別子（複数ルートが存在する場合のみ） (From API version 11)
  attr_accessor :route

  # 海域ボスの情報
  class BossInfo
    # 海域ゲージの状態
    # "NORMAL": 攻略中
    # "BREAK": 攻略後
    attr_accessor :military_gauge_status

    # 海域ゲージの最大値
    attr_accessor :ene_military_gauge_val

    # 海域ゲージの現在値
    attr_accessor :military_gauge_left

    # ボスの状態を表す文字列
    # FORM_1: 第1形態？
    attr_accessor :boss_status
  end
end
