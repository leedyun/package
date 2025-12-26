# coding: utf-8

module CandySql
  module Token

    def tokenize(src)
      res = []

      while !src.empty? do

        if src =~ /^('.*')/ || src =~ /^(".*")/

          # 文字列
          res << src.slice!(0,$1.length)

        elsif src =~ /^([\w\.]+)/

          # 変数
          res << src.slice!(0,$1.length)

        elsif src =~ /^([\s\t]+)/

          # 空白、タブは除外する
          src.slice!(0,$1.length)

        elsif src =~ /^(--|==|<=|>=|=<|<<|>>)/

          # 2文字以上記号
          res << src.slice!(0,$1.length)

        elsif src =~ /^\W/

          # 記号
          res << src.slice!(0,1)

        end

      end

      return res
    end

    module_function :tokenize
  end
end
