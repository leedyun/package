require 'spec_helper'

require_relative 'expected'

describe "Specification Example D - Software Reset Command" do
  it "Generates Expected Output" do
    command = MovingsignApi::SoftwareResetCommand.new

    command.sender = :pc
    command.receiver = 34

    expect(command.to_bytes).to eq EXAMPLE_D_EXPECTED
  end
end
