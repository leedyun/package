module MovingWords
  class CaptionBlock
    attr_accessor :start_time, :end_time, :content

    # Public: Sets up a new CaptionBlock with the given
    # start_time, end_time, and content.
    #
    # start_time - Offset in milliseconds from the
    #   beginning of the video to this `CaptionBlock`
    # end_time - Offset in milliseconds from the
    #   beginning of the video to the end of this
    #   `CaptionBlock`
    # content - The contents of this `CaptionBlock`
    def initialize(start_time, end_time, content)
      self.start_time  = start_time
      self.end_time = end_time
      self.content = content
    end

    # Public: Converts a millisecond offset to a more 
    # human-readable format of hh:mm:ss.
    #
    # offset_in_milliseconds - The millisecond offset to convert.
    # options - Formatting options
    #    milliseconds: Includes milliseconds in the
    #        display output.
    #
    # Examples:
    #
    #   CaptionBlock.human_offset(132212)
    #   => "2:12"
    #
    #   CaptionBlock.human_offset(132212, milliseconds: true)
    #   => "2:12.212"
    #
    #   CaptionBlock.human_offset(11075307)
    #   => "3:04:35"
    def self.human_offset(offset_in_milliseconds, options = {})
      hours = offset_in_milliseconds / 3600000
      minutes = (offset_in_milliseconds % 3600000) / 60000
      seconds = (offset_in_milliseconds % 60000) / 1000
      milliseconds = offset_in_milliseconds % 1000

      time = ""
      if hours > 0
        time << "#{hours}:"
        time << "%02d:" % minutes
      else
        time << "%1d:" % minutes
      end

      time << "%02d" % seconds

      if options[:milliseconds]
        time << ".%03d" % milliseconds
      end

      time
    end
  end
end