require 'test_helper'

describe ApplicationModule do
  it "autoloads submodules" do
    Animals.send(:remove_const, :Tiger) if defined?(Animals::Tiger)
    Animals::Tiger
  end

  it "autoloads submodules from models/views/controllers/etc subdirectories" do
    Animals.send(:remove_const, :TigersController) if defined?(Animals::TigersController)
    Animals::TigersController
  end

  it "can handle custom directories to autoload from" do
    Animals.send(:remove_const, :TigerDecorator) if defined?(Animals::TigerDecorator)
    Animals::TigerDecorator
  end

  it "knows the path of itself" do
    Animals.path.to_s.must_equal(
      "#{$dummy_path}/modules/animals"
    )
  end

  it "has an overridable view_path" do
    Animals.view_path.to_s.must_equal(
      "#{$dummy_path}/modules/animals/views"
    )
  end
end
