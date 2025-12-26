require "a1330ks_bmi/version"

module A1330ksBmi
  puts 'あなたのBMIを計算します'
  print'身長(cm)を入力:'
  height = gets.to_f / 100
  print'体重(kg)を入力:'
  weight = gets.to_f
  bmi = (weight / (height ** 2)).round(2)

  if bmi < 18.5
    judgment = "あなたの体型はは痩せ型です。"
  elsif bmi >= 18.5 && bmi < 25
    judgment = "あなたの体型は標準です。"
  elsif bmi > 25
    judgment = "あなたの体型は肥満です。"
  end

  puts "\nあなたのBMIは#{bmi}です。"
  puts "#{judgment}"
end
