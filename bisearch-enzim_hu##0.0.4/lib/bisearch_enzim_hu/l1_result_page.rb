require 'nokogiri'
require_relative 'fpcr_submitter'

module BisearchEnzimHu
  
  class L1ResultPage
    def initialize(f)
      @doc = Nokogiri::HTML(f)
      @table_hash = nil
    end
    
    def parse(deep=false)
      # select the table after the sequence: h2,h3,input
      table = @doc.css("h2+h3+input+table").first
      rows  = table.css("tr")
      header = rows.shift

      @table_hash = {}
      while !rows.empty?
        # line_a, line_b = rows.shift(2)
        line_a = rows.shift.css("td")
        line_bb = rows.shift
        line_b = line_bb.css("td")
        hh = { :line_a => line_a, :line_b => line_b }
        h = {}
        # 
        index = line_a[0].content.to_i
        # h[:index] = index
        h[:score] = line_a[1].content.to_f
        h[:pa]    = line_a[11].content.to_i
        h[:pea]   = line_a[12].content.to_i
        h[:len]   = line_a[13].content.to_i

        h[:fp]    = line_bb.css("input").select{|el| el["name"]=="fp"}.first
        h[:fp]    = h[:fp]["value"] if !h[:fp].nil?

        h[:rp]    = line_bb.css("input").select{|el| el["name"]=="rp"}.first
        h[:rp]    = h[:rp]["value"] if !h[:rp].nil?

        hh.each_pair do |i, line|
          h[i] = {}
          h[i][:seq]  = line[2].content
          h[i][:pos]  = line[3].content.to_i
          h[i][:plen] = line[4].content.to_i
          h[i][:gc]   = line[5].content.to_f
          h[i][:tm]   = line[6].content.to_f
          h[i][:otm]  = line[7].content.to_f
          h[i][:cpg]  = line[8].content
          h[i][:sa]   = line[9].content.to_i
          h[i][:sea]  = line[10].content.to_i
        end
        @table_hash[index] = h
      end

      proceed if deep
      @table_hash
    end

    private

    def proceed
      @table_hash.each_pair do |index, hash|
        l2_result_hash = BisearchEnzimHu::FpcrSubmitter.new.run(hash, index)
        
        @table_hash[index][:fpcr] = l2_result_hash
      end
    end
  end
end


# f = File.open("first_step_page.html")
# page = BisearchEnzimHu::L1ResultPage.new(f)

# puts page.parse
