# -*- encoding: utf-8 -*-

require "amatch"
require "moji"

module Acme
  class Smileage
    module Utils
      class Matcher
        attr_accessor :max_score

        def initialize(str)
          @str = str
          @max_score = 5
        end

        def match(targets)
          # 完全一致検索
          if r = targets.find {|e| e == @str }
            return r
          end

          # 正規化
          nstr = normalize(@str)
          ntargets = targets.map {|e| normalize(e) }

          # 大文字小文字を無視して完全一致検索
          if i = ntargets.index {|e| e == nstr }
            return targets[i]
          end

          # 大文字小文字を無視して前方一致検索 (最低でも 2 文字は必要)
          if nstr.length > 1 and i = ntargets.index {|e| e.start_with?(nstr) }
            return targets[i]
          end

          # 編集距離であいまい検索
          if i = index_by_amatch(@str, targets)
            return targets[i]
          end

          # 大文字小文字を無視して編集距離であいまい検索
          if i = index_by_amatch(nstr, ntargets)
            return targets[i]
          end

          nil
        end

        def index_by_amatch(str, targets)
          matcher = Amatch::Sellers.new(str)
          if r = targets.map.with_index {|e,i| [i, matcher.match(e)] }.sort_by {|e| e[1] }[0]
            return r[0] if r[1] < self.max_score # score があまりにも大きかったら無視
          end
        end

        def normalize(str)
          return nil unless str
          Moji.hira_to_kata(Moji.normalize_zen_han(str)).downcase.gsub(/\s+/, "")
        end
      end
    end
  end
end
