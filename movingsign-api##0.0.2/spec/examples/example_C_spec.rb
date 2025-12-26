require 'spec_helper'

require_relative 'expected'

describe "Specification Example C - Set Clock Command" do
  it "Generates Expected Output" do
    command = MovingsignApi::SetClockCommand.new

    command.sender = :pc
    command.receiver = 34

    command.datetime = Time.new(2004,04,02,12,36,23)

    expect(command.to_bytes).to eq EXAMPLE_C_EXPECTED
  end
end
