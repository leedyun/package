# coding: utf-8

module CandySql
  module Valiable

    def defin(src, var)
      val = []

      key = src[0]
      # 変数定義
      src.shift(2)
      src.each_with_index{ |s, i|
        if var.key?(s)
          src[i] = var[s]
        end
      }
      var[key] = src.join(" ")
      return var
    end

    def definAs(src, var)
      val = []

      key = src[0]
      if src[3] == "["
        # JOIN定義
        val << [src[2], "AS", key]
        src.shift(3)

        src.each{ |s|

          if s == "]"

          else
            if s == "["
              s = "ON"
            elsif var.key?(s)
              s = var[s]
            end
            val << s
          end
        }
      else
        # AS定義
        src.shift(2)
        src.each_with_index{ |s, i|
          if var.key?(s)
            src[i] = var[s]
          end
        }
        src << ["AS", key]
        val = src
      end
      var[key] = val.join(" ")
      return var
    end

    module_function :defin
    module_function :definAs
  end
end
