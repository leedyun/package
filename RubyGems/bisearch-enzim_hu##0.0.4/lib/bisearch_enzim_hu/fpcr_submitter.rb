require 'net/http'
require_relative 'l2_result_page'

module BisearchEnzimHu

  URL = "http://bisearch.enzim.hu/?run"
  class FpcrSubmitter
    def initialize(url=URL)
      @url = url
    end
    

    def run(hash, index)
      fp   = hash[:fp] || hash[:line_a][:seq] # forward primer
      rp   = hash[:rp] || hash[:line_b][:seq] # reverse primer
      fpcr = "#{fp}!#{rp}"
      db   = "Homo sapiens"

      params = {
        "bis" => "on", # bisulfite
        "db" => db, # database
        "fp" => fp, # forward primer
        "fpcr" => fpcr, # 
        "fpcr_but.x" => "35",
        "fpcr_but.y" => "6",
        "mm" => "0000000011111111", # mismatches
        "npcrres" => "100", # PCR product to show
        "nprimerres" => "100", # Primer matches to show
        "prg" => "cgi/fpcr.cgi", 
        "rp" => rp # reverse primer
      }

      uri = URI(@url)
      puts "---> starting FPCR"
      t = Time.now
      page = Net::HTTP.post_form(uri, params)
      puts "---> FPCR completed (time: #{Time.now-t}s)"

      # puts "--- save result to file: fpcr_result_#{index}.html"
      # File.open("fpcr_result_#{index}.html", 'w') {|f| f.write page.body }
      
      result_page = BisearchEnzimHu::L2ResultPage.new(page.body)
      result_page.parse # return an hash
    end
    
  end


end