require 'nokogiri'
require 'uri'

# parsa, legge e memorizza in un hash il contenuto della pagina 
# html con i risultati del secondo step

module BisearchEnzimHu
  
  class L2ResultPage
    HEAD = :head
    SENSE = :sense
    ANTISENSE = :antisense
    

    def initialize(f)
      @doc = Nokogiri::HTML(f)
      @direction = HEAD
      @hash = nil
    end
    
    def parse
      @hash = {}
      @doc.css("div.main").children.each_with_index do |el, i|

        d = detect_direction(el)
        if !d.nil?
          @direction = d
          @hash[@direction]           ||={}
          @hash[@direction][:results] ||=[]
          @hash[@direction][:matches]   ={}
        end

        detect_result(el)
        detect_matches(el, i)
      end
      @hash
    end

    private

    def detect_direction(el)
      if el.name=="h2"
        el.children.each do |el2|
          if el2.name=="a" && el2["name"]=="spcr"
            return SENSE
          elsif el2.name=="a" && el2["name"]=="aspcr"
            return ANTISENSE
          end
        end
      end
      nil
    end

    def detect_result(el)
      if el.name=="pre"
        el.children.each do |el2|
          if el2.name=="a"
            @hash[@direction][:results] << parse_ensembl_url(el2["href"])
          end
        end
      end
    end

    def detect_matches(el, i)
      if el.name.downcase=="h3" && el.children[0].name.downcase=="a" # && el.children[0]["name"]=~/^primer_s/
        if el.children[0]["name"]=="primer_senfp" # Matches of forward primer
          @hash[@direction][:matches][:forward] = @doc.css("div.main").children[i+1].content.to_i
        elsif el.children[0]["name"]=="primer_senrp" # Matches of reverse primer
          @hash[@direction][:matches][:reverse] = @doc.css("div.main").children[i+1].content.to_i
        end
      end
    end

    def parse_ensembl_url(uri)
      h = {}
      h[:url] = uri
      uri = URI(uri)
      uri.query.split("&").each do |pair|
        k, v = pair.split("=")
        if v
          k = k.to_sym
          v = v.to_i if [:start, :end].include? k
          h[k] = v
        end
      end
      h[:length] = h[:end] - h[:start]
      h
    end
  end
end

# f = File.open("second_step_result_page_3res.html")
# L2ResultPage.new(f).parse
