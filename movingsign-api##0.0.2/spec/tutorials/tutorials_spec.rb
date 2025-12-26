require 'spec_helper'

describe "Tutorial Examples" do
  describe "README Example 1" do
    it "Works" do
      pending "Todo"

      path = File.join(File.dirname(__FILE__), 'readme_1.rb')
      script = File.read(path)

      eval(File.read(path), nil, path)
    end
  end
end