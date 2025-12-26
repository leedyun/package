# 改装設計図一覧
class BlueprintListInfo
  # 艦型を表す数値
  # 艦娘図鑑では shipClass に文字列として入っているが、
  # 改装設計図一覧では数値として格納されており、仕様が変わっている。
  attr_accessor :ship_class_id

  # 艦番号（1〜）
  attr_accessor :ship_class_index

  # 艦種順でソートする際に使うキー
  attr_accessor :ship_sort_no

  # 艦種
  attr_accessor :ship_type

  # 艦名
  attr_accessor :ship_name

  # 艦娘のステータス画像（横長の画像）のファイル名
  attr_accessor :status_img

  # 改装設計図の総数
  attr_accessor :blueprint_total_num

  # 有効期限切れの警告を表示するか (From API version 8)
  attr_accessor :exists_warning_for_expiration

  # 有効期限の詳細
  attr_accessor :expiration_date_list

  class ExpirationDate
    # 有効期限を表す UNIX タイムスタンプ（ミリ秒含む）
    # 4月に入手した改装設計図の有効期限は 1505141999000 だった。
    # これは 2017-09-11 23:59:59 を表すタイムスタンプである。
    # しかし、SEGA 公式サイト上では「2017年9月末まで」と表示されていた。
    # この値は、月の単位までしか使われていない？
    attr_accessor :expiration_date

    # 上記の有効期限を持つ改装設計図の枚数
    attr_accessor :blueprint_num

    # 今月で有効期限切れかどうか (From API version 8)
    attr_accessor :expire_this_month
  end
end
