# frozen_string_literal: true

# This Karafka component is a Pro component under a commercial license.
# This Karafka component is NOT licensed under LGPL.
#
# All of the commercial components are present in the lib/karafka/pro directory of this
# repository and their usage requires commercial license agreement.
#
# Karafka has also commercial-friendly license, commercial support and commercial components.
#
# By sending a pull request to the pro components, you are agreeing to transfer the copyright of
# your code to Maciej Mensfeld.

module Karafka
  module Web
    module Pro
      module Ui
        module Lib
          module Policies
            # Extra configuration for pro UI
            class Config
              extend ::Karafka::Core::Configurable

              # Policies controller related to messages operations and visibility
              setting :messages, default: Policies::Messages.new

              # Policies controller related to all requests. It is a general one that is not
              # granular but can be used to block completely certain pieces of the UI from
              # accessing like explorer or any other as operates on the raw env level
              setting :requests, default: Policies::Requests.new

              configure
            end
          end
        end
      end
    end
  end
end
