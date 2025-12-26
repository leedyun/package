require 'movingsign_api/commands/command'
require 'movingsign_api/commands/internal/file_handle'
require 'movingsign_api/commands/internal/display_mode'
require 'movingsign_api/commands/internal/display_speed'
require 'movingsign_api/commands/internal/display_pause'
require 'movingsign_api/commands/internal/align_mode'

module MovingsignApi
  # Writes text to a sign
  class WriteTextCommand < MovingsignApi::Command
    # Index of the file to write to.  0 - 35 (363 total). See {FileHandle}
    #
    # @param value [Integer] 0 - 35 (default: 0)
    attr_accessor :file_handle

    # Display mode to use.  See {DisplayMode}
    #
    # @param value [Sybol] (default: +:hold+)
    attr_accessor :display_mode

    # Display speed of effects. See {DisplaySpeed}
    #
    # @param value [Symbol] default: +:normal+
    attr_accessor :display_speed

    # Display pause between screens of information.  See {DisplayPause}
    #
    # @param value [Integer] default: +2+
    attr_accessor :display_pause

    # Day of week mask.  See specification for an explaination of this parameter
    #
    # @param value [String] default: +'7F'+
    attr_accessor :dayofweek_mask

    # Align mode to use. See {AlignMode}
    #
    # @param value [Symbol] One of +:left+ +:right+ +:center+ (default +:left+)
    attr_accessor :align_mode

    # Display start time
    # @note work in progress
    #
    # @param value [String] default: +'0000'+
    attr_accessor :start_time

    # Display end time
    # @note work in progress
    #
    # @param value [String] default: +'2359'+
    attr_accessor :end_time

    # Text to display
    #
    # @param value [String] the message to display
    attr_accessor :text

    def file_handle=(handle)
      @file_handle = FileHandle.new(handle)
    end

    def display_mode=(mode)
      @display_mode = DisplayMode.parse(mode)
    end

    def display_speed=(speed)
      @display_speed = DisplaySpeed.parse(speed)
    end

    def display_pause=(seconds)
      @display_pause = DisplayPause.new seconds
    end

    def align_mode=(align)
      @align_mode = AlignMode.parse(align)
    end

    # (see Command#command_code)
    # 'A' for the "Write Text" command
    def command_code
      'A'
    end

    private

    def command_payload_bytes
      # set defaults if needed
      self.file_handle      ||= 0
      self.display_mode     ||= :hold
      self.display_speed    ||= :normal
      self.display_pause    ||= 2
      self.dayofweek_mask   ||= '7F'
      self.align_mode       ||= :left
      self.start_time       ||= '0000'
      self.end_time         ||= '2359'
      raise InvalidInputError, "text not set" unless self.text

      bytes = []

      bytes.concat self.file_handle.to_bytes     # Filename
      bytes.concat self.display_mode.to_bytes           # Display Mode
      bytes.concat self.display_speed.to_bytes           # Display Speed
      bytes.concat self.display_pause.to_bytes           # Display Pause
      bytes.concat string_to_ascii_bytes(self.dayofweek_mask)           # Show Date
      bytes.concat string_to_ascii_bytes(self.start_time)           # Start Time
      bytes.concat string_to_ascii_bytes(self.end_time)           # End Time
      bytes.concat string_to_ascii_bytes('000')           # Reserved
      bytes.concat self.align_mode.to_bytes           # Align Mode
      #bytes.concat string_to_ascii_bytes("\xFD\x42" + self.text.gsub("\n", "\x7F"))           # Text
      bytes.concat string_to_ascii_bytes(self.text)           # Text

      bytes
    end
  end
end

