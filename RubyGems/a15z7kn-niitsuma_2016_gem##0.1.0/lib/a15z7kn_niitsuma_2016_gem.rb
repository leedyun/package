# -*- coding: utf-8 -*-
require "a15z7kn_niitsuma_2016_gem/version"

module A15z7knNiitsuma2016Gem
  class Main

    # 整数を入力として受け取り，値が奇数ならば真を返す
    def odd? n
      n % 2 == 1
    end

    # 引数が0以外ではじまる4桁の数字であり，なおかつ，値が偶数ならば 真を返す
    def check_number? n
      n > 999 and not odd? n
    end

    # 文字列を受け取り，その長さが3文字以上，8文字以下であれば 真を返す
    def enough_length? s
      s.length > 2 and s.length < 9
    end

    # 引数として割る数と割られる数を取り，割り算をした結果を返す． ただし，0で割り算をしたら例外を発生する
    def divide n1, n2
      n2 / n1
    end

    # 引数に数値を1つとる．3の倍数の時は”Fizz”を返す． 5の倍数の時は”Buzz”を返す．3と5の公倍数のときは”FizzBuzz”を返す．
    def fizz_buzz n
      return "FizzBuzz" if n % 15 == 0
      return "Buzz" if n % 5 == 0
      return "Fizz" if n % 3 == 0
      ""
    end

    # 標準出力に「Hello」と表示するプログラムのテストと実装を行いなさい
    def say_hello
      print "Hello"
    end

  end
end
