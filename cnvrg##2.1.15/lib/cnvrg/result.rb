require 'fileutils'
module Cnvrg
  class Result
    attr_reader :msg, :msg_color, :e_msg, :e_msg_backtrace

    def initialize(success, msg, e_msg = "", e_backtrace = "")
      begin
       @success = success
        @msg = msg
       @e_msg = e_msg
       @e_msg_backtrace = e_backtrace
        if !@success
          @msg_color = Thor::Shell::Color::RED
        else
          @msg_color = Thor::Shell::Color::GREEN

        end
      rescue => e
      end

    end
    def is_success?
      return @success
    end

  end


  end
