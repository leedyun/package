module MovingWords
  class SrtParser
    attr_accessor :data

    # Public: Sets up a new parser based on the given
    # data.
    def initialize(data)
      self.data = data
    end

    # Public: Converts the caption data to a set of
    # `CaptionBlock` objects.
    #
    # Returns an array of `CaptionBlock`s
    def parse
      blocks = []
      block_content = ""
      data.each_line do |line|
        if line.strip.empty?
          blocks << parse_caption_block(block_content) unless block_content.empty?
          block_content = ""
        else
          block_content += line
        end
      end

      # Handle any final content
      blocks << parse_caption_block(block_content) unless block_content.empty?

      blocks
    end

    # Internal: Converts a caption block in the SRT
    # data to a `CaptionBlock` object.
    #
    # block_content - The text for the content block
    #   to parse.
    #
    # Returns a `CaptionBlock`
    def parse_caption_block(block_content)
      lines = block_content.split("\n")

      time_line = lines[1]
      times = time_line.split("-->")
      times = times.map { |t| t.strip }

      start_time = subrip_time_to_ms(times[0])
      end_time = subrip_time_to_ms(times[1])
      content = lines[2..-1].join("\n")

      CaptionBlock.new(start_time, end_time, content)
    end

    # Internal: Converts a subrip time code to milliseconds
    #
    # subrip_time  - The subrip time string
    def subrip_time_to_ms(subrip_time)
      seconds, millis = subrip_time.split(",")
      hours, minutes, seconds = seconds.split(":")

      millis.to_i + (seconds.to_i * 1000) + (minutes.to_i * 60000) + (hours.to_i * 3600000)
    end
  end
end