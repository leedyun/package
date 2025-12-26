module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module ConfigListHelpers
      def config_list_ol_id
        "ol_#{element_form_id(:action => :config_list)}"
      end
    end
  end
end
