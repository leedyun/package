# coding: utf-8

module CandySql
  module Interpreter

    def statement(src, var)

      if src[1] == "--"
        if  src[0] == "G"

          src[0] = "GROUP BY"

        elsif src[0] == "O"

          src[0] = "ORDER BY"

        elsif src[0] == "H"

          src[0] = "HAVING"

        else
          if src[0] == "S"

            src[0] = "SELECT"
          
          elsif src[0] == "F"

            src[0] = "FROM"

          elsif src[0] == "W"

            src[0] = "WHERE"

          end
          src.each_with_index do |t, i|
            if t == "=<"
              src[i] = "INNER JOIN"
              src.insert( i, "\n" )
            elsif t == "<<"
              src[i] = "LEFT JOIN"
              src.insert( i, "\n" )
            elsif t == ">>"
              src[i] = "RIGHT JOIN"
              src.insert( i, "\n" )
            elsif var.key?(t)
              src[i] = var[t]
              if src[i+1] == ","
                src[i+1] = ",\n"
              end
            end
          end
        end
        src.slice!( 1, 1 )

      elsif src[1] == "-"

        if src[0] == "A"

          src[0] = "AND"

        elsif src[0] == "O"

          src[0] = "OR"

        end
        src.slice!( 1, 1 )
        src.each_with_index do |t, i|
          if var.key?(t)
            src[i] = var[t]
          end
        end
      end

      return src.join(" ").gsub(/\s\(/, "(").gsub(/\s,/, ",")
    end

    module_function :statement
  end
end
