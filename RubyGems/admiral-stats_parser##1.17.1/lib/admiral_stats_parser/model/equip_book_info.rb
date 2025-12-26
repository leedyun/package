# 装備図鑑
class EquipBookInfo
  # 図鑑No.
  attr_accessor :book_no

  # 種別
  # 未取得の場合は、空文字列
  attr_accessor :equip_kind

  # 装備名
  # 未取得の場合は、空文字列
  attr_accessor :equip_name

  # 一覧に表示する画像のファイル名
  # 未取得の場合は、空文字列
  attr_accessor :equip_img
end
