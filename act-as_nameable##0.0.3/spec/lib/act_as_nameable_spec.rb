require 'spec_helper'

describe ActAsNameable do
  subject { ActAsNameable }

  it { should respond_to :root }
  it { subject.root.class.should == Pathname }
end
