module AppleNewsClient
  module Style
    class LinearGradientFill < Base
      include GradientFill
      required_property :type, "linear_gradient"
      optional_property :angle
    end
  end
end
