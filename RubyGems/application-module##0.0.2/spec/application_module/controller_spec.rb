require 'test_helper'

class AnimalsTigersControllerTest < ActionController::TestCase
  def setup
    @controller = Animals::TigersController.new
  end

  test "makes Rails find the views inside the module directory" do
    get :index
    assert_includes response.body, "tigers#index"
  end
end

