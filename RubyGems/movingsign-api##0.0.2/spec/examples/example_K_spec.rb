require 'spec_helper'

require_relative 'expected'

describe "Specification Example K - Hard Reset Command" do
  it "Generates Expected Output" do
    command = MovingsignApi::HardResetCommand.new

    command.sender = :pc
    command.receiver = 16

    expect(command.to_bytes).to eq EXAMPLE_K_EXPECTED
  end
end
