module LangCard

  class Card
    attr_reader :name, :source, :target, :part_of_speech, :example
    
    def initialize name, source, target, part_of_speech, example
      @name, @source, @target, @part_of_speech, @example =
      name, source, target, part_of_speech, example
    end

    def attributes
      [@name, @source, @target, @part_of_speech, @example]
    end
  end

end
