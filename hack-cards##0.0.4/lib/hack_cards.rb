require "hack_cards/version"

module HackCards

  class Card
    attr_accessor :text, :url, :image

    def initialize(image: "", text: "", url: "")
      @image = image if image.length > 0
      @text = text if text.length > 0
      @url = url if url.length > 0
    end

    def components
      r = []
      r << :image if image
      r << :text if text
      r << :url if url
      return r
    end

    def type
      string = components.reduce("") {|s, c| s + "_" + c.to_s}
      string[1..-1].to_sym
    end

    def display
      if type == :text
        return text_partial
      elsif type == :url
        return url_partial
      elsif type == :text_url
        return text_url_partial
      end
    end

    def text_partial
      "<p>#{text}</p>"
    end

    def url_partial
      # TODO url partial
    end

    def text_url_partial
      # TODO text url partial
    end
  end
end
