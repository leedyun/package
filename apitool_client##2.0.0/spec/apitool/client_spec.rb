require 'spec_helper'

describe Apitool::Client do

  it "should have a version" do
    expect(Apitool::Client::VERSION).not_to be nil
  end

end
