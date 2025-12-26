# coding: utf-8

require 'candy--sql/version'
require 'candy--sql/interpreter'
require 'candy--sql/token'
require 'candy--sql/variable'

module CandySql

  def make(filename)

    mode = 0 #(0: 変数定義、1: SQL構文)
    var = {}
    res = []

    open(filename) { |file|
      while row = file.gets

        # トークン分割
        src = CandySql::Token.tokenize(row)

        if mode == 0
          if src[1] == "=="
            # AS定義
            var = var.merge( CandySql::Valiable.definAs(src, var) )
          elsif src[1] == "="
            # 変数定義
            var = var.merge( CandySql::Valiable.defin(src, var) )
          elsif src[1] == "<"
            # サブクエリ定義
            tmp = "(" + CandySql.make(src[2][1 .. -2]) + ")"
            src.slice!( 2, 2 )
            src.insert(2, tmp)
            src[1] = "="
            var = var.merge( CandySql::Valiable.definAs(src, var) )
          elsif src[1] == "--"
            mode = 1
          end
        end
        
        if mode == 1
          # SQL構文
          res << CandySql::Interpreter.statement(src, var)
        end
        
      end
    }

    return res.join("\n")
  end

  module_function :make
end
