require 'spec_helper'

require_relative 'expected'

describe "Specification Example A - Write Text File" do
  it "Generates Expected Output" do
    command = MovingsignApi::WriteTextCommand.new

    command.sender = :pc
    command.receiver = 3

    command.file_handle = 'A' # aka 10
    command.display_mode = :auto
    command.display_speed = :faster
    command.display_pause = 2
    command.dayofweek_mask = '7F' # todo: make this pretty
    command.start_time = '0100'
    command.end_time = '1200'
    command.align_mode = :left
    command.text = 'HELLO'

    expect(command.to_bytes).to eq EXAMPLE_A_EXPECTED
  end
end
