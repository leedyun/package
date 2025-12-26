class ABBYY::Cloud
  module Namespaces
    # Base class for namespaces
    # Every namespace carries shared settings and defines its own methods
    class Base
      include Dry::Initializer.define -> do
        param :settings
      end
    end
  end
end
