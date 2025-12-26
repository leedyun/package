# 装備一覧
class EquipListInfo
  # 種別を表す数値
  # 装備図鑑の種別のほうが細かいので、こちらを使うメリットはほとんどない。
  # 強いて言えば、提督情報のページと同じ表現に揃えたい場合か。
  # 1: 主砲
  # 2: 副砲・高角
  # 3: 魚雷
  # 4: 艦戦
  # 5: 艦爆・艦攻
  # 6: 偵察機
  # 7: ソナー・爆雷
  # 8: その他
  attr_accessor :type

  # 図鑑No.
  attr_accessor :equipment_id

  # 装備名
  attr_accessor :name

  # 所持数
  attr_accessor :num

  # アイコン画像のファイル名
  attr_accessor :img
end
