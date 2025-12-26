# 艦娘図鑑
class TcBookInfo
  # 図鑑No.
  attr_accessor :book_no

  # 艦型
  # 未取得の場合は、空文字列
  attr_accessor :ship_class

  # 艦番号（1〜）
  # 未取得の場合は、-1
  attr_accessor :ship_class_index

  # 艦種
  # 未取得の場合は、空文字列
  attr_accessor :ship_type

  # 艦名
  # 未取得の場合は、"未取得"
  attr_accessor :ship_name

  # 一覧に表示する画像のファイル名
  # 未取得の場合は、空文字列
  attr_accessor :card_index_img

  # 取得済み画像のファイル名
  # Array
  # 未取得の場合は、空の Array
  attr_accessor :card_img_list

  # 画像のバリエーション数
  # 未取得の場合は、0
  attr_accessor :variation_num

  # 取得済みの画像数
  # 未取得の場合は、0
  attr_accessor :acquire_num

  # Lv. (From API version 2)
  # 未取得の場合は、0
  attr_accessor :lv

  # 艦娘のステータス画像（横長の画像）のファイル名 (From API version 2)
  # Array
  # 未取得の場合は、空の Array
  attr_accessor :status_img

  # ケッコンカッコカリ済みかどうかを表す配列
  # その図鑑No. にノーマルと改があれば要素数2、ノーマルしかなければ要素数1の配列
  # 要素数2の場合、1個目の要素がノーマル、2個目の要素が改を表す
  attr_accessor :is_married

  # ケッコンカッコカリ済み画像の配列
  # その図鑑No. にノーマルと改があっても、ノーマルのみでも、要素数1
  attr_accessor :married_img
end
